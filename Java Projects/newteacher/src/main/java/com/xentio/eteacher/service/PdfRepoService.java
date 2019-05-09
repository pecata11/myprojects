package com.xentio.eteacher.service;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.imageio.ImageIO;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.xentio.eteacher.domain.LessonImage;
import com.xentio.eteacher.domain.PdfFile;

@Service("pdfRepoService")
@Transactional(rollbackFor={Exception.class})
public class PdfRepoService {
	@Autowired
	private SessionFactory sessionFactory;

	public List<PdfFile> getPdfFiles() {
		Session session = sessionFactory.getCurrentSession();
		Query q = session.createQuery("FROM PdfFile ORDER BY createTime DESC");
		return q.list();
	}
	
	public List<Long> getPdfPages(long pdfId) {
		Session session = sessionFactory.getCurrentSession();
		Query q = session.createQuery("SELECT id FROM LessonImage WHERE pdfId = :pdfId AND (isCropped is null or isCropped = false) ORDER BY pageNum");
		q.setLong("pdfId", pdfId);
		
		return q.list();
	}

	public List<Long> getAllImageIds() {
		Session session = sessionFactory.getCurrentSession();
		Query q = session.createQuery("SELECT id FROM LessonImage");
		return q.list();
	}

	public void save(PdfFile pdfFile) {
		Session session = sessionFactory.getCurrentSession();
		session.save(pdfFile);
	}
	
	public LessonImage getImage(long id) {
		Session session = sessionFactory.getCurrentSession();
		LessonImage image = (LessonImage)session.createQuery("FROM LessonImage WHERE id=" + id).uniqueResult();
		return image;
	}

	public void update(LessonImage image) {
		Session session = sessionFactory.getCurrentSession();
		session.saveOrUpdate(image);
	}
	
	public long uploadPDF(String fileName, byte[] content) throws Exception {
		Session session = sessionFactory.getCurrentSession();
		
    	PdfFile pdfFile = new PdfFile();
    	pdfFile.setFileName(fileName);
    	pdfFile.setCreateTime(new Date());
    	session.save(pdfFile);
    	
    	extractImagesPdfBox(content, pdfFile.getId(), session);
    	return pdfFile.getId();
	}
	/*
	private void extractIcePdf(byte[] content, long pdfId, Session session)
			throws Exception {
		float scale = 1.0f;
		float rotation = 0f;
		
		Document document = new Document();
		document.setByteArray(content, 0, content.length, null);
		for (int i = 0; i < document.getNumberOfPages();) {
			 BufferedImage bufferedImage = (BufferedImage)
			            document.getPageImage(i,
			                                  GraphicsRenderingHints.SCREEN,
			                                  Page.BOUNDARY_CROPBOX, rotation, scale);
			 
			 ByteArrayOutputStream baOutStream = new ByteArrayOutputStream();
				ImageIO.write(bufferedImage, "jpg", baOutStream);

				LessonImage image = new LessonImage();
				image.setContent(baOutStream.toByteArray());
				image.setModifyTime(new Date());
				image.setPageNum(++i);
				image.setPdfId(pdfId);

				session.save(image);
		}

	}
	
	private void extractClown(byte[] content, long pdfId, Session session)
			throws Exception {

		Document document = new Document(new File(new Buffer(content)));

		// 3. Rasterize the first page!
		Renderer renderer = new Renderer();
		for (int i = 0; i < document.getNumberOfPages(); i++) {
			BufferedImage bufferedImage = renderer.render(document.getPages()
					.get(i), new Dimension(1400, 850));
			ByteArrayOutputStream baOutStream = new ByteArrayOutputStream();
			ImageIO.write(bufferedImage, "png", baOutStream);

			LessonImage image = new LessonImage();
			image.setContent(baOutStream.toByteArray());
			image.setModifyTime(new Date());
			image.setPageNum(++i);
			image.setPdfId(pdfId);

			session.save(image);
		}
	}
	*/

	private void extractImagesPdfBox(byte[] content, long pdfId, Session session) throws Exception {
		PDDocument document = null;
		try {
			document = PDDocument.load(new ByteArrayInputStream(content));

			List<?> pages = document.getDocumentCatalog().getAllPages();
			Iterator<?> iter = pages.iterator();
			int i = 0;
			while (iter.hasNext()) {
				PDPage page = (PDPage) iter.next();
				BufferedImage bufferedImage = page.convertToImage();

				ByteArrayOutputStream baOutStream = new ByteArrayOutputStream();
				ImageIO.write(bufferedImage, "png", baOutStream);

				LessonImage image = new LessonImage();
				image.setContent(baOutStream.toByteArray());
				image.setModifyTime(new Date());
				image.setPageNum(++i);
				image.setPdfId(pdfId);

				session.save(image);
			}
		} finally {
			if (document != null) {
				document.close();
			}
		}
	}
	public static byte[] doCrop(byte[] content, double left, double top, double width, double height) throws IOException {
		InputStream in = new ByteArrayInputStream(content);
		BufferedImage outImage = ImageIO.read(in);
		
/*		System.out.println(left);
		System.out.println(top);
		System.out.println(width);
		System.out.println(height);*/
		if(left + width > outImage.getWidth()){ //an intent to solve: java.awt.image.RasterFormatException: (x + width) is outside of Raster
			left = 0;
			width = outImage.getWidth();
		}
		if(top + height > outImage.getHeight()){ //an intent to solve: java.awt.image.RasterFormatException: (x + width) is outside of Raster
			top = outImage.getHeight();
			height = 0;
		}

		BufferedImage cropped = outImage.getSubimage((int)left, (int)top, (int)width, (int)height);

		ByteArrayOutputStream croppedOut = new ByteArrayOutputStream();
		ImageIO.write(cropped, "png", croppedOut);//TODO keep image type
		return croppedOut.toByteArray();
	}
/*
	private void extractImages(byte[] content, long pdfId, Session session) throws Exception {
        ByteBuffer buf = ByteBuffer.allocate(content.length);
        buf.put(content);
    	
        PDFFile pdffile = new PDFFile(buf);

        int numPages = pdffile.getNumPages();

        for (int i = 1; i <= numPages; i++) {
	        PDFPage page = pdffile.getPage(i);
	
	        Rectangle rect = new Rectangle(0, 0,
	                (int) page.getBBox().getWidth(),
	                (int) page.getBBox().getHeight());
	
	        Image img = page.getImage(
	                rect.width, rect.height, //width & height
	                rect, // clip rect
	                null, // null for the ImageObserver
	                true, // fill background with white
	                true // block until drawing is done
	                );
	
	        BufferedImage bufferedImage = new BufferedImage(rect.width, rect.height, BufferedImage.TYPE_INT_RGB);
	        Graphics g = bufferedImage.createGraphics();
	        g.drawImage(img, 0, 0, null);
	        g.dispose();
	
	        ByteArrayOutputStream result = new ByteArrayOutputStream();
			ImageIO.write(bufferedImage, "png", result);
			
			LessonImage image = new LessonImage();
	    	image.setContent(result.toByteArray());
	    	image.setModifyTime(new Date());
	    	image.setPageNum(i);
	    	image.setPdfId(pdfId);
	    	
	    	session.save(image);
        }
    }
*/
		
		
//		private void extractImagess(byte[] content, long pdfId, Session session) throws Exception {
//			PdfReader reader = new PdfReader(new ByteArrayInputStream(content));
////			PdfReaderContentParser parser = new PdfReaderContentParser(reader);
//			int numPages = reader.getNumberOfPages();
//			
//			
//			 RandomAccessFileOrArray ra = new RandomAccessFileOrArray(content);
////			 int n = JBIG2Image.getNumberOfPages(ra);
//			 com.itextpdf.text.Image img;
//		        for (int i = 1; i <= numPages; i++) {
//		            img = JBIG2Image.getJbig2Image(ra, i);
//		            byte[] images = img.getRawData();
//		            System.out.println();
//		        }
//			
////			com.itextpdf.text.Rectangle psize = reader.getPageSize(1);
////			float width = psize.getWidth();
////			float height = psize.getHeight();
////
//////			Document document = new Document(psize);
//////
//////			              
//////
//////			PdfWriter writer = PdfWriter.getInstance(document,
//////
//////			              new FileOutputStream("D:\\thumbnail.pdf"));
//////
//////			document.open();
////
////			System.out.println("Tampered? " + reader.isTampered());
////
////			PdfImportedPage page = writer.getImportedPage(reader, 1);
////
////			com.itextpdf.text.Image image = com.itextpdf.text.Image.getInstance(reader.getPageContent(0));
////
////			              
////
////			              
////
////			byte[] imgOut = image.getOriginalData();
////			
////			
////			
////			
////			for (int i = 1; i <= reader.getNumberOfPages(); i++) {
////				byte[] pageContent = reader.getPageContent(i);
////				InputStream in = new ByteArrayInputStream(pageContent);
////				BufferedImage bufferedImage = ImageIO.read(in);
////				
//////				com.itextpdf.text.Rectangle pageSize = reader.getPageSize(i);
//////				
//////				Rectangle rect = new Rectangle(0, 0,
//////		                (int) pageSize.getWidth(),
//////		                (int) pageSize.getHeight());
////		
//////		        Image img = reader.getImage(
//////		                rect.width, rect.height, //width & height
//////		                rect, // clip rect
//////		                null, // null for the ImageObserver
//////		                true, // fill background with white
//////		                true // block until drawing is done
//////		                );
//////		
//////		        BufferedImage bufferedImage = new BufferedImage(rect.width, rect.height, BufferedImage.TYPE_INT_RGB);
//////		        Graphics g = bufferedImage.createGraphics();
//////		        g.drawImage(img, 0, 0, null);
//////		        g.dispose();
////		
////		        ByteArrayOutputStream result = new ByteArrayOutputStream();
////				ImageIO.write(bufferedImage, "jpg", result);
////				
////				LessonImage image = new LessonImage();
////		    	image.setContent(result.toByteArray());
////		    	image.setModifyTime(new Date());
////		    	image.setPageNum(i);
////		    	image.setPdfId(pdfId);
////		    	
////		    	session.save(image);
//
//				
//				
////			}
//		}
		
}
