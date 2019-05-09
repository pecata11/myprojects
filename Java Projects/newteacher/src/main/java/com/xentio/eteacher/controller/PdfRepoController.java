package com.xentio.eteacher.controller;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;

import com.xentio.eteacher.domain.LessonImage;
import com.xentio.eteacher.domain.PdfFile;
import com.xentio.eteacher.domain.User;
import com.xentio.eteacher.service.PdfRepoService;
import com.xentio.eteacher.service.StudentService;

@Controller
@RequestMapping("/pdfRepo")
@SessionAttributes("user")
public class PdfRepoController {
	public static Map<Long, String[]> imageRealSize = new HashMap<Long, String[]>();

	@Autowired
	private StudentService studentService;
	
	@Autowired
	private PdfRepoService pdfRepoService;
	
	static final int FILE_NAME_LENGTH = 50;
	
	@ModelAttribute("user")
	public User createUser() {
		UserDetails userDetails = (UserDetails) SecurityContextHolder
				.getContext().getAuthentication().getPrincipal();
		User user = studentService.searchByUsername(userDetails.getUsername());
		return user;
	}
	
	  @RequestMapping(value = "/list", method = RequestMethod.GET)
	    public String getHomePage(Model model) {
	    	List<PdfFile> pdfFiles = pdfRepoService.getPdfFiles();
	    	
	    	for(PdfFile file:pdfFiles)
	    	{
	    		if(file.getFileName().length() > FILE_NAME_LENGTH)
	    		{
	    			String fileNameTruncated = file.getFileName().substring(0, FILE_NAME_LENGTH);
	    			file.setFileName(fileNameTruncated);
	    		}
	    	}
	    	model.addAttribute("pdfFiles", pdfFiles);
	    	
	    	return "pdf/pdfRepo";
		}

    @RequestMapping(value = "/upload", method = RequestMethod.POST)
   	public String postUpload(@RequestParam("file") MultipartFile file, Model model) {
    	
    	if(file.isEmpty()) {
    		model.addAttribute("uploadError", "No file selected!");
    		return "pdf/pdfRepo";
    	}
    	
        try {
	    	if (file.getContentType() == null ||
	    			(//!file.getContentType().startsWith("image") && 
	    			!file.getContentType().startsWith("application/pdf"))) {
	    		model.addAttribute("uploadError", "Please select a PDF file!");
	    		return "pdf/pdfRepo";
	    	}

	    	if(file.getBytes().length > 5242880) {
	    		model.addAttribute("uploadError", "Please upload an file of size < 5MB.");
	    		return "pdf/pdfRepo";
	    	}

	    	pdfRepoService.uploadPDF(file.getOriginalFilename(), file.getBytes());
		} catch (Exception e) {
			model.addAttribute("uploadError", "An unexpected error has occured. Please try again!");
    		return "pdf/pdfRepo";

		}
    	
       	return "redirect:list";
    }

    
    @RequestMapping(value = "/pdfFileNames", method = RequestMethod.GET)
	public @ResponseBody List<PdfFile>  getPdfFileNames() {
    	List<PdfFile> pdfFileNames = pdfRepoService.getPdfFiles();
		return pdfFileNames;
    }
    
    @RequestMapping(value = "/pdfPages", method = RequestMethod.GET)
	public @ResponseBody List<Long>  getPdfPages(@RequestParam(value = "pdfId") long pdfId) {
    	List<Long> pdfPages = pdfRepoService.getPdfPages(pdfId);
		return pdfPages;
    }
    
    @RequestMapping(value = "/exportAllImages", method = RequestMethod.GET)
	public String exportAllImages(@RequestParam(value = "password") String password, Model model) {
    	System.out.println("EXPORT ALL IMAGES");
    	
    	if (!"DoNotRunAccidently".equals(password)) {
        	model.addAttribute("result", "Incorrect password");
        	return "pdf/exportAllImages";
    	}
    	
    	List<Long> imageIds = pdfRepoService.getAllImageIds();
    	int successCount = 0;
    	int failCount = 0;
    	
    	for (Long imageId : imageIds) {
    		try {
	    		LessonImage image = pdfRepoService.getImage(imageId);
		    	InputStream in = new ByteArrayInputStream(image.getContent());
				BufferedImage outImage = ImageIO.read(in);

				File exportDir = new File ("export");
				if (!exportDir.exists()) {
					exportDir.mkdir();
				}
				
				File outputfile = new File("export" + File.separatorChar + "image_" + imageId + ".png");
			    ImageIO.write(outImage, "png", outputfile);
			    successCount++;
    		} catch (IOException e) {
    			e.printStackTrace();
    			failCount++;
    		}
    	}

    	System.out.println("DONE EXPORTING IMAGES");
    	
    	model.addAttribute("result", "SUCCESS");
    	model.addAttribute("successCount", successCount);
    	model.addAttribute("failCount", failCount);

    	return "pdf/exportAllImages";
    }

    
    @RequestMapping(value = "/{imageId}")
    @ResponseBody
    public byte[] loadImage(@PathVariable long imageId, Model model)  {
    	LessonImage image = pdfRepoService.getImage(imageId);
    	
    	if(image == null) {
    		return null;
    	}
    	try {
	    	InputStream in = new ByteArrayInputStream(image.getContent());
			BufferedImage outImage = ImageIO.read(in);
			
			String[] realSizeArray = new String[2];
			realSizeArray[0] = "" + outImage.getWidth();
			realSizeArray[1] = "" + outImage.getHeight();

			File outputfile = new File("saved.png");
		    ImageIO.write(outImage, "png", outputfile);
			
		    imageRealSize.put(imageId, realSizeArray);
			
    	} catch(Exception e) {
    		e.printStackTrace();
    	}
    	
   		return image.getContent();
    }
    
    @RequestMapping(value = "/imageRealSize", method = RequestMethod.GET)
	public @ResponseBody String[]  getImageRealSize(@RequestParam(value = "imageId") Long imageId) {
		return imageRealSize.get(imageId);
    }
    
    
}
