using System;
using System.Text;
using System.IO;
using System.Collections.Generic;
using ClearSlideLibrary.Dom;
using ClearSlideLibrary.Animations;

namespace ClearSlideLibrary.HtmlController
{
    public class HtmlController
    {
        private readonly int _numberOfSlides;
        private readonly int _allSlidesCount;
        private readonly int _slideIndex;
        private readonly string _fileName;
        private readonly string _baseFileName;
        private readonly string _filePath;
        private readonly StringBuilder _htmlPart;
        private readonly PPTSlide _mSlide;
        private const string JS_DIR_NAME = "temp";
        public int SlideWidth { get; set; }
        public int SlideHeight { get; set; }


        public HtmlController(string filepath, string filename,
                              PPTSlide aSlide, int slideCounter, int slidesNumber)
        {
            _baseFileName = filename;
            try
            {
                if (filename.Length != 0)
                {
                    if (slidesNumber != 1)
                    {
                        this._fileName = filename +"_" +slideCounter.ToString();
                    }
                    else
                    {
                        this._fileName = filename;
                    }
                }
                this._mSlide = aSlide;
                _numberOfSlides = 1;
                _allSlidesCount = slidesNumber;
                _slideIndex = slideCounter;
                this._filePath = filepath;
                this._htmlPart = new StringBuilder();
            }
            catch (ArgumentNullException ex)
            {
                Console.WriteLine("The passed value for filename:" + ex.Message);
                return;
            }
        }

        public void GenerateHtml()
        {
            this.GenerateHeader();
            this.GenerateBody();
            this.WriteTofile(_htmlPart);
        }

        private void WriteTofile(StringBuilder content)
        {
            string htmlFilePath = this._filePath + "\\" + this._fileName;
            string outFileName = htmlFilePath + ".html";
            FileStream fs = File.Create(outFileName, 1024);
            Byte[] htmlcontent = new UTF8Encoding(true).GetBytes(content.ToString());
            fs.Write(htmlcontent, 0, htmlcontent.Length);
            fs.Close();

            string outputDirWithFileNameAdded = Path.Combine(_filePath, _fileName);
            CopyJSFiles(_filePath, outputDirWithFileNameAdded);
        }

        private void CopyJSFiles(string destinationDirForHtmlFile, string newOutputDir)
        {
            string sourceDir = Path.Combine(destinationDirForHtmlFile, JS_DIR_NAME);
            string destDir = newOutputDir;
            DirectoryInfo src = new DirectoryInfo(sourceDir);
            DirectoryInfo dest = new DirectoryInfo(destDir);
            FileInfo[] files = src.GetFiles();
            foreach (FileInfo file in files)
            {
                try
                {
                    if (file.Exists)
                    {
                        file.CopyTo(Path.Combine(dest.FullName,
                                                 file.Name));
                    }
                }
                catch (IOException iex)
                {
                    Console.WriteLine(iex.Message);
                }
            }
        }

        private void GenerateHeader()
        {
            string numbers = DynamicHeaderJSPart();
            AppendHeader(numbers);
        }

        private string DynamicHeaderJSPart()
        {
            if (_numberOfSlides == 1)
            {
                return "[0,1,1]";
            }
            else
            {
                int count = 0;
                StringBuilder numbers = new StringBuilder();
                numbers.Append("[");
                while (count <= _numberOfSlides - 1)
                {
                    numbers.Append(count.ToString());
                    numbers.Append(",");
                    count++;
                }
                numbers.Append(count);
                int length = numbers.ToString().Length;
                string outputString = numbers.ToString().Remove(length - 1, 1);
                return outputString + "]";
            }
        }

        private void AppendHeader(string numbers)
        {
            string SC = ".SC {height: " + SlideHeight + "px; width: " + SlideWidth + "px; display: none;}";
            string DC = ".DC1 {top: 0px; left: 0px; height: 100%; width: 100%; opacity: 1; }";
            string DC0 = ".DC0 {top: 0px; left: 0px; height: 100%; width: 100%; opacity: 0;}";
            _htmlPart.Append("<!DOCTYPE html>");
            _htmlPart.Append("<html><head>");
            _htmlPart.Append("<title>" + this._fileName + "</title>");
            _htmlPart.Append("<meta content=\"text/html;charset=UTF-8\"  http-equiv=\"content-type\"/>");
            _htmlPart.Append("<meta content=\"width=device-width, initial-scale=1,"
                             + "maximum-scale=1, user-scalable=0\"name=\"viewport\"/>");
            _htmlPart.Append("<link href=\"" + this._fileName + "/c.css\" rel=\"stylesheet\" type=\"text/css\"/>");
            _htmlPart.Append("<script type=\"text/javascript\" src=\"" + this._fileName + "/jquery.js\"></script>");
            _htmlPart.Append("<script type=\"text/javascript\" src=\"" + this._fileName + "/animationUtils.js\"></script>");
            _htmlPart.Append("<script type=\"text/javascript\" src=\"" + this._fileName + "/animations.js\"></script>");
            _htmlPart.Append("<script type=\"text/javascript\" src=\"" + this._fileName + "/player.js\"></script>");
            _htmlPart.Append("<script type=\"text/javascript\">var gv = {w: 0,h: 0,t: 1,a: " +
                             "'" + this._fileName + "'" + ",v: 0,sh:" + SlideHeight + ",sw:" + SlideWidth + ",s: 0,i:" + numbers +
                             ",f:1,r:1};</script>");
            _htmlPart.Append("<style type=\"text/css\">" + SC + "</style>");
            _htmlPart.Append("<style type=\"text/css\">" + DC + DC0 + "</style>");
            _htmlPart.Append("</head>");
        }

        private void GenerateBody()
        {
            _htmlPart.Append("<body id=\"bodyid\""
                             + "style=\"background-color:Black;height:100%;width:100%;overflow:hidden;margin:0px;" +
                             "user-select: none;-khtml-user-select: none;-ms-user-select: none;-o-user-select: text;" +
                             "-webkit-user-select: none;-moz-user-select: none;-webkit-tap-highlight-color:rgba(0,0,0,0);\"" +
                             "onkeydown=\"keychanger(event)\">");
            AppendPlayer();
            _htmlPart.Append("<div id=\"resizer\" style=\"left:0px;top:0px;height:" + SlideHeight + "px;width:" + SlideWidth + "px; overflow:hidden;-moz-transform-origin: 0 0;-o-transform-origin: 0 0;  -webkit-transform-origin: 0 0; -ms-transform-origin: 0 0;\">");

            DynamicBodyPart();

            _htmlPart.Append("<div id=\"loadingImg\" style=\"height:100%;width:100%;display:none;\">");
            _htmlPart.Append("<img style=\"height:30px;width:130px;top:255px;left:295px;\" src=\"" + this._fileName + "/pre.gif\" />");
            _htmlPart.Append("</div>");
            _htmlPart.Append("</div>");
            _htmlPart.Append("<script type=\"text/javascript\">");
            

            string staticJS =
                (_mSlide.advanceAfterTime >= 0 ? "var advanceAfterSlide='" + _mSlide.advanceAfterTime + "'; var advanceSlideUrl = '" + _baseFileName + "_" + (_slideIndex + 1) + ".html?autoStart=true';" : "") +
                "var lastAnimationPlaying=false;if ((document.createElement('canvas').getContext) ? true : false) { if (gv.b != 1) gfl(); $(window).resize(resizer);$(document).ready(resizer);" +
                "if(window.location.toString().indexOf(\"autoStart=true\")>0){$(window).bind('load', atLoadAutoStart); }else { $(window).bind('load', atload);}" +
                "} else { document.getElementById('resizer').innerHTML = ''; document.getElementById('toolbar').innerHTML = '';  document.getElementById('toolbar').style.width = '0px'; document.getElementById('idpre').innerHTML =" +
                "'Oops! Your browser does not support HTML5. You need to upgrade your browser to view this presentation.' }";

            //Dynamic part from the generated JavaScript file.
            string anima = new ClearSlideLibrary.Animations.JSONGenerator(_mSlide).GetAnimaVariable();

            _htmlPart.Append(staticJS);
            _htmlPart.Append(anima);            
            _htmlPart.Append("</script>");
            _htmlPart.Append("</body></html>");
        }

        private void DynamicBodyPart()
        {
            if (_numberOfSlides != 0)
            {
                ////foreach (PPTSlide pptSlide in _mSlides)
                ////{
                string dirpath = Path.Combine(_filePath, _fileName);
                HtmlSlide slide = new HtmlSlide(_mSlide.Id, "SC", this._fileName, dirpath, _mSlide.slideIndex)
                {
                    ContainerShape = _mSlide.ContainerShape
                };
                _htmlPart.Append(slide.DrawElement());

                //}
            }
        }

        private void AppendPlayer()
        {
            _htmlPart.Append("<div id=\"idpre\" style=\"z-index:1000;height:100%;width:100%;color:white;\">");
            _htmlPart.Append("<img id=\"play\" style=\"display:none;height:200px;width:200px;cursor:pointer;position:absolute;\"");
            _htmlPart.Append("onclick=\"fnPre()\" src=\"" + this._fileName + "/pre.png\" alt=\"click to begin\" />");
            _htmlPart.Append("</div>");

            _htmlPart.Append("<div class=\"toolbar\" id=\"toolbar\" style=\"bottom:0px;\">");
            _htmlPart.Append("<div id=\"ddiv\" style=\"height:50px;\">");

            _htmlPart.Append("<div class=\"\" id=\"time\" style=\"display:none;\">");
            _htmlPart.Append("<span id=\"times\" style=\"font-weight:bold; color: #525151;\">00:00</span>");
            _htmlPart.Append("</div>");

            _htmlPart.Append("<div class=\"progress\" id=\"progress\" style=\"display:none;-moz-transform-origin: 0 0;-o-transform-origin: 0 0;-webkit-transform-origin: 0 0; -ms-transform-origin: 0 0;opacity:0;\">");

            _htmlPart.Append("<div class=\"progressbar\" id=\"Bar\"> </div>");
            _htmlPart.Append("</div>");
            String nextUrl = _slideIndex >= _allSlidesCount ? "'" + _fileName + ".html'" : "'" + _baseFileName + "_" + (_slideIndex + 1) + ".html?autoStart=true'";
            String prevUrl = _slideIndex <= 1 ? "'" + _fileName + ".html'" : "'" + _baseFileName + "_" + (_slideIndex - 1) + ".html?autoStart=true'";
            _htmlPart.Append("<div id=\"buttonDiv\" style=\"width:150px; height:50px; opacity:0;\">");
            _htmlPart.Append("<div class=\"next\" style=\"background-image: url('" + this._fileName + "/arrow.png')\" onclick=\"window.location = " + nextUrl + " ; fnPre()\"></div>");
            _htmlPart.Append("<div class=\"next2\" style=\"background-image: url('" + this._fileName + "/arrow.png')\" onclick=\"next()\"></div>");
            _htmlPart.Append("<div class=\"play\" id=\"playB\" style=\"background-image: url('" + this._fileName + "/arrow.png')\" onclick=\"next()\"></div>");
            _htmlPart.Append("<div class=\"prev\" style=\"background-image: url('" + this._fileName + "/arrow.png')\" onclick=\"window.location = " + prevUrl + "; fnPre()\"></div>");
            _htmlPart.Append("<div class=\"prev2\" style=\"background-image: url('" + this._fileName + "/arrow.png')\" onclick=\"prev()\"></div>");
            _htmlPart.Append("</div>");

            _htmlPart.Append("<div id=\"status\" style=\"display:none;width:34px;height:21px;\" title=\"goto\">");

            _htmlPart.Append("<div id=\"statustotal\" style=\"top:1px;left:16px;font-size:14px;\">/ 1</div>");
            _htmlPart.Append("<input id=\"current\" style=\"width:10px; top:3px;font-size:14px; height:16px;\" onkeypress=\"EnterCurrent(event)\"  maxlength=\"1\" type=\"text\"/>");
            _htmlPart.Append("</div>");
            _htmlPart.Append("</div>");
            _htmlPart.Append("</div>");
        }
    }
}