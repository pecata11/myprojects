package org.apache.jsp.WEB_002dINF.jsp.dashboard;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class dashboard_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List _jspx_dependants;

  static {
    _jspx_dependants = new java.util.ArrayList(1);
    _jspx_dependants.add("/WEB-INF/jsp/dashboard/../header.jsp");
  }

  private org.apache.jasper.runtime.TagHandlerPool _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody;
  private org.apache.jasper.runtime.TagHandlerPool _005fjspx_005ftagPool_005fsec_005fauthorize_0026_005fifAnyGranted;
  private org.apache.jasper.runtime.TagHandlerPool _005fjspx_005ftagPool_005fform_005fform_0026_005fmodelAttribute_005fmethod_005fid_005fclass_005faction;
  private org.apache.jasper.runtime.TagHandlerPool _005fjspx_005ftagPool_005fform_005fhidden_0026_005fpath_005fnobody;
  private org.apache.jasper.runtime.TagHandlerPool _005fjspx_005ftagPool_005fform_005fselect_0026_005fpath_005fcssStyle;
  private org.apache.jasper.runtime.TagHandlerPool _005fjspx_005ftagPool_005fform_005foptions_0026_005fitems_005fnobody;
  private org.apache.jasper.runtime.TagHandlerPool _005fjspx_005ftagPool_005fc_005fforEach_0026_005fvarStatus_005fvar_005fitems;
  private org.apache.jasper.runtime.TagHandlerPool _005fjspx_005ftagPool_005fc_005fif_0026_005ftest;
  private org.apache.jasper.runtime.TagHandlerPool _005fjspx_005ftagPool_005fform_005fcheckbox_0026_005fvalue_005fpath_005fnobody;
  private org.apache.jasper.runtime.TagHandlerPool _005fjspx_005ftagPool_005fc_005fout_0026_005fvalue_005fnobody;
  private org.apache.jasper.runtime.TagHandlerPool _005fjspx_005ftagPool_005ffmt_005fformatDate_0026_005fvalue_005ftype_005fpattern_005fnobody;
  private org.apache.jasper.runtime.TagHandlerPool _005fjspx_005ftagPool_005fform_005fcheckbox_0026_005fpath_005fonclick_005fnobody;

  private javax.el.ExpressionFactory _el_expressionfactory;
  private org.apache.AnnotationProcessor _jsp_annotationprocessor;

  public Object getDependants() {
    return _jspx_dependants;
  }

  public void _jspInit() {
    _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody = org.apache.jasper.runtime.TagHandlerPool.getTagHandlerPool(getServletConfig());
    _005fjspx_005ftagPool_005fsec_005fauthorize_0026_005fifAnyGranted = org.apache.jasper.runtime.TagHandlerPool.getTagHandlerPool(getServletConfig());
    _005fjspx_005ftagPool_005fform_005fform_0026_005fmodelAttribute_005fmethod_005fid_005fclass_005faction = org.apache.jasper.runtime.TagHandlerPool.getTagHandlerPool(getServletConfig());
    _005fjspx_005ftagPool_005fform_005fhidden_0026_005fpath_005fnobody = org.apache.jasper.runtime.TagHandlerPool.getTagHandlerPool(getServletConfig());
    _005fjspx_005ftagPool_005fform_005fselect_0026_005fpath_005fcssStyle = org.apache.jasper.runtime.TagHandlerPool.getTagHandlerPool(getServletConfig());
    _005fjspx_005ftagPool_005fform_005foptions_0026_005fitems_005fnobody = org.apache.jasper.runtime.TagHandlerPool.getTagHandlerPool(getServletConfig());
    _005fjspx_005ftagPool_005fc_005fforEach_0026_005fvarStatus_005fvar_005fitems = org.apache.jasper.runtime.TagHandlerPool.getTagHandlerPool(getServletConfig());
    _005fjspx_005ftagPool_005fc_005fif_0026_005ftest = org.apache.jasper.runtime.TagHandlerPool.getTagHandlerPool(getServletConfig());
    _005fjspx_005ftagPool_005fform_005fcheckbox_0026_005fvalue_005fpath_005fnobody = org.apache.jasper.runtime.TagHandlerPool.getTagHandlerPool(getServletConfig());
    _005fjspx_005ftagPool_005fc_005fout_0026_005fvalue_005fnobody = org.apache.jasper.runtime.TagHandlerPool.getTagHandlerPool(getServletConfig());
    _005fjspx_005ftagPool_005ffmt_005fformatDate_0026_005fvalue_005ftype_005fpattern_005fnobody = org.apache.jasper.runtime.TagHandlerPool.getTagHandlerPool(getServletConfig());
    _005fjspx_005ftagPool_005fform_005fcheckbox_0026_005fpath_005fonclick_005fnobody = org.apache.jasper.runtime.TagHandlerPool.getTagHandlerPool(getServletConfig());
    _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
    _jsp_annotationprocessor = (org.apache.AnnotationProcessor) getServletConfig().getServletContext().getAttribute(org.apache.AnnotationProcessor.class.getName());
  }

  public void _jspDestroy() {
    _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.release();
    _005fjspx_005ftagPool_005fsec_005fauthorize_0026_005fifAnyGranted.release();
    _005fjspx_005ftagPool_005fform_005fform_0026_005fmodelAttribute_005fmethod_005fid_005fclass_005faction.release();
    _005fjspx_005ftagPool_005fform_005fhidden_0026_005fpath_005fnobody.release();
    _005fjspx_005ftagPool_005fform_005fselect_0026_005fpath_005fcssStyle.release();
    _005fjspx_005ftagPool_005fform_005foptions_0026_005fitems_005fnobody.release();
    _005fjspx_005ftagPool_005fc_005fforEach_0026_005fvarStatus_005fvar_005fitems.release();
    _005fjspx_005ftagPool_005fc_005fif_0026_005ftest.release();
    _005fjspx_005ftagPool_005fform_005fcheckbox_0026_005fvalue_005fpath_005fnobody.release();
    _005fjspx_005ftagPool_005fc_005fout_0026_005fvalue_005fnobody.release();
    _005fjspx_005ftagPool_005ffmt_005fformatDate_0026_005fvalue_005ftype_005fpattern_005fnobody.release();
    _005fjspx_005ftagPool_005fform_005fcheckbox_0026_005fpath_005fonclick_005fnobody.release();
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html; charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">\n");
      out.write("<html>\n");
      out.write("<head>\n");
      out.write("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"../../css/main.css\"/>\n");
      out.write("<script src=\"http://code.jquery.com/jquery-1.8.1.min.js\"></script>\n");
      out.write("<title>Quench</title>\n");
      out.write("</head>\n");
      out.write("<body>\n");
      out.write("\n");
      out.write("\n");
      out.write('\n');
      out.write('\n');
      out.write('\n');
      if (_jspx_meth_c_005furl_005f0(_jspx_page_context))
        return;
      out.write("\n");
      out.write("\n");
      out.write("<div class=\"nav\">\n");
      out.write("  <div class=\"innerWidth\">\n");
      out.write("    <ul>\n");
      out.write("      ");
      if (_jspx_meth_sec_005fauthorize_005f0(_jspx_page_context))
        return;
      out.write("\n");
      out.write("      \n");
      out.write("\t\t");
      if (_jspx_meth_sec_005fauthorize_005f1(_jspx_page_context))
        return;
      out.write("\n");
      out.write("       \t\n");
      out.write("       <!--  ");
      if (_jspx_meth_sec_005fauthorize_005f2(_jspx_page_context))
        return;
      out.write("\n");
      out.write("\t\t-->\n");
      out.write("    </ul>\n");
      out.write("  </div>\n");
      out.write("</div>\n");
      out.write("\n");
      out.write("<div class=\"header\">\n");
      out.write("  <div class=\"innerWidth\">\n");
      out.write("   <!-- <div class=\"logo\">Education Project</div>-->\n");
      out.write("  </div>\n");
      out.write("</div>\n");
      out.write("\n");
      out.write("\n");
      out.write("<div class=\"innerWidth\">\n");
      out.write("<div class=\"page\">\n");
      out.write("\n");
      out.write("<!-- <h1>Dashboard</h1>-->\n");
      out.write("\n");
      if (_jspx_meth_c_005furl_005f10(_jspx_page_context))
        return;
      out.write('\n');
      if (_jspx_meth_c_005furl_005f11(_jspx_page_context))
        return;
      out.write('\n');
      out.write('\n');
      if (_jspx_meth_form_005fform_005f0(_jspx_page_context))
        return;
      out.write("\n");
      out.write("\n");
      out.write("<div id=\"idMainDiv\" class=\"scrollDashboard\">\n");
      out.write("\n");
      out.write("</div>\n");
      out.write("\t\n");
      out.write("</div>\n");
      out.write("</div>\n");
      out.write("\n");
      if (_jspx_meth_c_005furl_005f12(_jspx_page_context))
        return;
      out.write('\n');
      if (_jspx_meth_c_005furl_005f13(_jspx_page_context))
        return;
      out.write("\n");
      out.write("\n");
      out.write("<script>\n");
      out.write("$(document).ready(function() {\n");
      out.write("\tvar dashboardInitParams = localStorage.getItem('dashboardInitParams');\n");
      out.write("\tif(dashboardInitParams){\n");
      out.write("\t\tvar v = JSON.parse(dashboardInitParams)\n");
      out.write("\t\t$('#classId').val(v.classId);\n");
      out.write("\t\t$('#subjectId').val(v.subjectId);\n");
      out.write("\t\t$('#groupId').val(v.groupId);\n");
      out.write("\t\t$('#lessonsGoals').val(v.lessonsGoals);\n");
      out.write("\t\t\n");
      out.write("\t\tajaxGroups(v.groupId);\n");
      out.write("\t}\n");
      out.write("\t\n");
      out.write("\tvar classId = $('#classId').val();\n");
      out.write("\tif(!classId){\n");
      out.write("\t\t$(\"input[type=button]\").attr(\"disabled\", \"disabled\");\n");
      out.write("\t\t$('#subjectId').prop('disabled', 'disabled');\n");
      out.write("\t\talert('Class is missing. Create a class.');\n");
      out.write("\t}\n");
      out.write("});\n");
      out.write("\n");
      out.write("function loadDashboard() {\n");
      out.write("\tif($('#classId').val() < 0){\n");
      out.write("\t\talert('Choose a Class!');\n");
      out.write("\t\treturn;\n");
      out.write("\t}\n");
      out.write("\t$('#excludedStudentIds').val('');\n");
      out.write("\t$('#sortByColumn').val('');\n");
      out.write("\t$('#sortDirection').val('');\n");
      out.write("\t\n");
      out.write("\t$('#cellColorDiv').removeAttr(\"style\", \"display:true\");\n");
      out.write("\t\n");
      out.write("\treloadDashboard();\n");
      out.write("}\n");
      out.write("function reloadDashboard() {\n");
      out.write("\tif($('#lessonsGoals').val() == 1){\n");
      out.write("\t\t$('#loadedContent').hide();\n");
      out.write("\t\t$('#controls').hide();\n");
      out.write("    var classId = $('#classId').val();\n");
      out.write("\t\tvar subjectId = $('#subjectId').val();\n");
      out.write("\t\tvar groupId = $('#groupId').val();\n");
      out.write("    $('#idMainDiv').load('/api/dashboard/ajaxResultGoals?classId=' + classId + '&subjectId=' + subjectId + '&groupId=' + groupId);\n");
      out.write("\t}\n");
      out.write("\tif($('#lessonsGoals').val() == 2){\n");
      out.write("\t\t$('#loadedContent').show();\n");
      out.write("\t\t$('#controls').show();\n");
      out.write("    $.ajax({\n");
      out.write("\t\t    url: '");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${ajaxLoadDashboardUrl}", java.lang.String.class, (PageContext)_jspx_page_context, null, false));
      out.write("',\n");
      out.write("\t\t    type:'POST',\n");
      out.write("\t\t    data: $('#idFormDashboard').serializeArray(),\n");
      out.write("\t\t\tdataType: \"json\",\n");
      out.write("\t\t\tcomplete: function(transport){\n");
      out.write("\t\t\t\tvar data = transport.responseText;\n");
      out.write("\t\t   \t\t$('#idMainDiv').html(data);\n");
      out.write("\t\t    }\n");
      out.write("\n");
      out.write("\t\t  });\n");
      out.write("\t}\n");
      out.write("}\n");
      out.write("\n");
      out.write("function resetGroups() {\n");
      out.write("\t$.ajax({\n");
      out.write("\t    url: '");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${ajaxResetGroupsUrl}", java.lang.String.class, (PageContext)_jspx_page_context, null, false));
      out.write("',\n");
      out.write("\t    type:'POST',\n");
      out.write("\t    data: $('#idFormDashboard').serializeArray(),\n");
      out.write("\t\tdataType: \"json\",\n");
      out.write("\t\tcomplete: function(transport){\n");
      out.write("\t\t\tvar data = transport.responseText;\n");
      out.write("\t\t\tloadDashboard();\n");
      out.write("\t   \t}\n");
      out.write("\n");
      out.write("\t  });\n");
      out.write("}\n");
      out.write("\n");
      out.write("function saveToLocalStorage() {\n");
      out.write("\tvar classId = $('#classId').val();\n");
      out.write("\tvar subjectId = $('#subjectId').val();\n");
      out.write("\tvar groupId = $('#groupId').val();\n");
      out.write("\tvar lessonsGoals = $('#lessonsGoals').val();\n");
      out.write("\t\n");
      out.write("\tvar dashboardInitParams = {\n");
      out.write("\t\t\tclassId: classId,\n");
      out.write("\t\t\tsubjectId: subjectId,\n");
      out.write("\t\t\tgroupId: groupId,\n");
      out.write("\t\t\tlessonsGoals: lessonsGoals\n");
      out.write("        }\n");
      out.write("\tlocalStorage.setItem('dashboardInitParams', JSON.stringify(dashboardInitParams));\n");
      out.write("}\n");
      out.write("\n");
      out.write("window.onbeforeunload = function (e) {\n");
      out.write("\tsaveToLocalStorage();\n");
      out.write("};\n");
      out.write("\t\n");
      out.write("$('#classId').change(function() {\n");
      out.write("\tvar classId = $('#classId').val();\n");
      out.write("\tvar subjectId = $('#subjectId').val();\n");
      out.write("\t $.ajax({\n");
      out.write("\t        url: '");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${ajaxPicksGroups}", java.lang.String.class, (PageContext)_jspx_page_context, null, false));
      out.write("',\n");
      out.write("\t        type:'GET',\n");
      out.write("\t        data: ({classId : classId,subjectId:subjectId}),\n");
      out.write("\t    \tdataType: \"json\",\n");
      out.write("\t    \tcomplete: function(transport){\n");
      out.write("\t    \t\tvar data = transport.responseText;\n");
      out.write("\t    \t\tdata = $.parseJSON(data);\n");
      out.write("\t    \t\tvar listItems = \"\";\n");
      out.write("\t\t   \t\tfor (var i = 0; i < data.length; i++){\n");
      out.write("\t\t\t      listItems+= \"<option value='\" + data[i].id + \"'>\" + data[i].name + \"</option>\";\n");
      out.write("\t\t\t    }\n");
      out.write("\t\t   \t\t$('#groupId').html(listItems);\n");
      out.write("\t\t\t\tif($('#lessonsGoals').val() == 1) {\n");
      out.write("\t\t\t\t\treloadDashboard();\n");
      out.write("\t\t\t\t} else {\n");
      out.write("\t\t\t   \t\tajaxLessons();\n");
      out.write("\t\t\t   \t}\n");
      out.write("\t        }\n");
      out.write("\t      });\n");
      out.write("});\n");
      out.write("\n");
      out.write("\n");
      out.write("$('#subjectId').change(function() {\n");
      out.write("\tajaxGroups();\n");
      out.write("});\n");
      out.write("\n");
      out.write("function ajaxGroups(savedGroupId) {\n");
      out.write("\t\n");
      out.write("\tvar subjectId = $('#subjectId').val();\n");
      out.write("\tvar classId = $('#classId').val();\n");
      out.write("\t\n");
      out.write("\t $.ajax({\n");
      out.write("\t        url: '");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${ajaxPicksGroups}", java.lang.String.class, (PageContext)_jspx_page_context, null, false));
      out.write("',\n");
      out.write("\t        type:'GET',\n");
      out.write("\t        data: ({subjectId : subjectId,classId:classId}),\n");
      out.write("\t    \tdataType: \"json\",\n");
      out.write("\t    \tcomplete: function(transport){\n");
      out.write("\t    \t\tvar data = transport.responseText;\n");
      out.write("\t    \t\tdata = $.parseJSON(data);\n");
      out.write("\t    \t\tvar listItems = \"\";\n");
      out.write("\t\t   \t\tfor (var i = 0; i < data.length; i++){\n");
      out.write("\t\t\t      listItems+= \"<option value='\" + data[i].id + \"'>\" + data[i].name + \"</option>\";\n");
      out.write("\t\t\t    }\n");
      out.write("\t\t   \t\t$('#groupId').html(listItems);\n");
      out.write("\t\t   \t\t\n");
      out.write("\t\t   \t\tif(savedGroupId) {\n");
      out.write("\t\t   \t\t\t$('#groupId').val(savedGroupId);\n");
      out.write("\t\t\t\t}\n");
      out.write("\t\t\t\tif($('#lessonsGoals').val() == 1) {\n");
      out.write("\t\t\t\t\treloadDashboard();\n");
      out.write("\t\t\t\t} else {\n");
      out.write("\t\t\t   \t\tajaxLessons();\n");
      out.write("\t\t\t   \t}\n");
      out.write("\t        }\n");
      out.write("\t      });\n");
      out.write("}\n");
      out.write("$('#groupId').change(function() {\n");
      out.write("\tif($('#lessonsGoals').val() == 1) {\n");
      out.write("\t\treloadDashboard();\n");
      out.write("\t} else {\n");
      out.write("\t\tajaxLessons();\n");
      out.write("\t}\n");
      out.write("});\n");
      out.write("\n");
      out.write("function ajaxLessons() {\n");
      out.write("\t$('#idMainDiv').html('');\n");
      out.write("\t\n");
      out.write("\tvar classId = $('#classId').val();\n");
      out.write("\tvar subjectId = $('#subjectId').val();\n");
      out.write("\tvar groupId = $('#groupId').val();\n");
      out.write("\tif(groupId)\n");
      out.write("\t{\n");
      out.write("\t $('#loadedContent').load('/api/dashboard/ajaxLessons?classId=' + classId + '&subjectId=' + subjectId + '&groupId=' + groupId + ' #loadedContent');\n");
      out.write("\t}\n");
      out.write("}\n");
      out.write("\n");
      out.write("$('#lessonsGoals').change(function() {\n");
      out.write("\treloadDashboard();\n");
      out.write("});\n");
      out.write("\n");
      out.write("reloadDashboard();\n");
      out.write("</script>\n");
      out.write("\n");
      out.write("</body>\n");
      out.write("</html>");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try { out.clearBuffer(); } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }

  private boolean _jspx_meth_c_005furl_005f0(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  c:url
    org.apache.taglibs.standard.tag.rt.core.UrlTag _jspx_th_c_005furl_005f0 = (org.apache.taglibs.standard.tag.rt.core.UrlTag) _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.get(org.apache.taglibs.standard.tag.rt.core.UrlTag.class);
    _jspx_th_c_005furl_005f0.setPageContext(_jspx_page_context);
    _jspx_th_c_005furl_005f0.setParent(null);
    // /WEB-INF/jsp/dashboard/../header.jsp(4,0) name = var type = java.lang.String reqTime = false required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f0.setVar("logoutUrl");
    // /WEB-INF/jsp/dashboard/../header.jsp(4,0) name = value type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f0.setValue("/api/auth/logout");
    int _jspx_eval_c_005furl_005f0 = _jspx_th_c_005furl_005f0.doStartTag();
    if (_jspx_th_c_005furl_005f0.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f0);
      return true;
    }
    _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f0);
    return false;
  }

  private boolean _jspx_meth_sec_005fauthorize_005f0(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  sec:authorize
    org.springframework.security.taglibs.authz.JspAuthorizeTag _jspx_th_sec_005fauthorize_005f0 = (org.springframework.security.taglibs.authz.JspAuthorizeTag) _005fjspx_005ftagPool_005fsec_005fauthorize_0026_005fifAnyGranted.get(org.springframework.security.taglibs.authz.JspAuthorizeTag.class);
    _jspx_th_sec_005fauthorize_005f0.setPageContext(_jspx_page_context);
    _jspx_th_sec_005fauthorize_005f0.setParent(null);
    // /WEB-INF/jsp/dashboard/../header.jsp(9,6) name = ifAnyGranted type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_sec_005fauthorize_005f0.setIfAnyGranted("ROLE_ADMIN,ROLE_USER");
    int _jspx_eval_sec_005fauthorize_005f0 = _jspx_th_sec_005fauthorize_005f0.doStartTag();
    if (_jspx_eval_sec_005fauthorize_005f0 != javax.servlet.jsp.tagext.Tag.SKIP_BODY) {
      out.write("\n");
      out.write("\n");
      out.write("       \t");
      if (_jspx_meth_c_005furl_005f1(_jspx_th_sec_005fauthorize_005f0, _jspx_page_context))
        return true;
      out.write("\n");
      out.write("       \t<li><a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${dashboardUrl}", java.lang.String.class, (PageContext)_jspx_page_context, null, false));
      out.write("\">Dashboard</a></li>\n");
      out.write("       \t\n");
      out.write("       \t");
      if (_jspx_meth_c_005furl_005f2(_jspx_th_sec_005fauthorize_005f0, _jspx_page_context))
        return true;
      out.write("\n");
      out.write("       \t<li><a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${adminUrl}", java.lang.String.class, (PageContext)_jspx_page_context, null, false));
      out.write("\">Admin</a></li>\n");
      out.write("      \n");
      out.write("       \t");
      if (_jspx_meth_c_005furl_005f3(_jspx_th_sec_005fauthorize_005f0, _jspx_page_context))
        return true;
      out.write("\n");
      out.write("       \t<li><a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${lessonUrl}", java.lang.String.class, (PageContext)_jspx_page_context, null, false));
      out.write("\">Lessons</a></li>\n");
      out.write("   \t\t\n");
      out.write("   \t\t");
      if (_jspx_meth_c_005furl_005f4(_jspx_th_sec_005fauthorize_005f0, _jspx_page_context))
        return true;
      out.write("\n");
      out.write("       \t<li><a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${lessonUrl}", java.lang.String.class, (PageContext)_jspx_page_context, null, false));
      out.write("\">Feedback</a></li>\n");
      out.write("\n");
      out.write("   \t\t");
      if (_jspx_meth_c_005furl_005f5(_jspx_th_sec_005fauthorize_005f0, _jspx_page_context))
        return true;
      out.write("\n");
      out.write("       \t<li><a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${goalUrl}", java.lang.String.class, (PageContext)_jspx_page_context, null, false));
      out.write("\">Goals</a></li>\n");
      out.write("\n");
      out.write("       \t\n");
      out.write("       \t<li><a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${logoutUrl}", java.lang.String.class, (PageContext)_jspx_page_context, null, false));
      out.write("\">Logout</a></li>\n");
      out.write("      ");
    }
    if (_jspx_th_sec_005fauthorize_005f0.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fsec_005fauthorize_0026_005fifAnyGranted.reuse(_jspx_th_sec_005fauthorize_005f0);
      return true;
    }
    _005fjspx_005ftagPool_005fsec_005fauthorize_0026_005fifAnyGranted.reuse(_jspx_th_sec_005fauthorize_005f0);
    return false;
  }

  private boolean _jspx_meth_c_005furl_005f1(javax.servlet.jsp.tagext.JspTag _jspx_th_sec_005fauthorize_005f0, PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  c:url
    org.apache.taglibs.standard.tag.rt.core.UrlTag _jspx_th_c_005furl_005f1 = (org.apache.taglibs.standard.tag.rt.core.UrlTag) _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.get(org.apache.taglibs.standard.tag.rt.core.UrlTag.class);
    _jspx_th_c_005furl_005f1.setPageContext(_jspx_page_context);
    _jspx_th_c_005furl_005f1.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_sec_005fauthorize_005f0);
    // /WEB-INF/jsp/dashboard/../header.jsp(11,8) name = var type = java.lang.String reqTime = false required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f1.setVar("dashboardUrl");
    // /WEB-INF/jsp/dashboard/../header.jsp(11,8) name = value type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f1.setValue("/api/dashboard/");
    int _jspx_eval_c_005furl_005f1 = _jspx_th_c_005furl_005f1.doStartTag();
    if (_jspx_th_c_005furl_005f1.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f1);
      return true;
    }
    _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f1);
    return false;
  }

  private boolean _jspx_meth_c_005furl_005f2(javax.servlet.jsp.tagext.JspTag _jspx_th_sec_005fauthorize_005f0, PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  c:url
    org.apache.taglibs.standard.tag.rt.core.UrlTag _jspx_th_c_005furl_005f2 = (org.apache.taglibs.standard.tag.rt.core.UrlTag) _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.get(org.apache.taglibs.standard.tag.rt.core.UrlTag.class);
    _jspx_th_c_005furl_005f2.setPageContext(_jspx_page_context);
    _jspx_th_c_005furl_005f2.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_sec_005fauthorize_005f0);
    // /WEB-INF/jsp/dashboard/../header.jsp(14,8) name = var type = java.lang.String reqTime = false required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f2.setVar("adminUrl");
    // /WEB-INF/jsp/dashboard/../header.jsp(14,8) name = value type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f2.setValue("/api/admin/");
    int _jspx_eval_c_005furl_005f2 = _jspx_th_c_005furl_005f2.doStartTag();
    if (_jspx_th_c_005furl_005f2.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f2);
      return true;
    }
    _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f2);
    return false;
  }

  private boolean _jspx_meth_c_005furl_005f3(javax.servlet.jsp.tagext.JspTag _jspx_th_sec_005fauthorize_005f0, PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  c:url
    org.apache.taglibs.standard.tag.rt.core.UrlTag _jspx_th_c_005furl_005f3 = (org.apache.taglibs.standard.tag.rt.core.UrlTag) _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.get(org.apache.taglibs.standard.tag.rt.core.UrlTag.class);
    _jspx_th_c_005furl_005f3.setPageContext(_jspx_page_context);
    _jspx_th_c_005furl_005f3.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_sec_005fauthorize_005f0);
    // /WEB-INF/jsp/dashboard/../header.jsp(17,8) name = var type = java.lang.String reqTime = false required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f3.setVar("lessonUrl");
    // /WEB-INF/jsp/dashboard/../header.jsp(17,8) name = value type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f3.setValue("/api/lesson/");
    int _jspx_eval_c_005furl_005f3 = _jspx_th_c_005furl_005f3.doStartTag();
    if (_jspx_th_c_005furl_005f3.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f3);
      return true;
    }
    _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f3);
    return false;
  }

  private boolean _jspx_meth_c_005furl_005f4(javax.servlet.jsp.tagext.JspTag _jspx_th_sec_005fauthorize_005f0, PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  c:url
    org.apache.taglibs.standard.tag.rt.core.UrlTag _jspx_th_c_005furl_005f4 = (org.apache.taglibs.standard.tag.rt.core.UrlTag) _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.get(org.apache.taglibs.standard.tag.rt.core.UrlTag.class);
    _jspx_th_c_005furl_005f4.setPageContext(_jspx_page_context);
    _jspx_th_c_005furl_005f4.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_sec_005fauthorize_005f0);
    // /WEB-INF/jsp/dashboard/../header.jsp(20,5) name = var type = java.lang.String reqTime = false required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f4.setVar("lessonUrl");
    // /WEB-INF/jsp/dashboard/../header.jsp(20,5) name = value type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f4.setValue("/api/feedbackForm/feedback/");
    int _jspx_eval_c_005furl_005f4 = _jspx_th_c_005furl_005f4.doStartTag();
    if (_jspx_th_c_005furl_005f4.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f4);
      return true;
    }
    _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f4);
    return false;
  }

  private boolean _jspx_meth_c_005furl_005f5(javax.servlet.jsp.tagext.JspTag _jspx_th_sec_005fauthorize_005f0, PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  c:url
    org.apache.taglibs.standard.tag.rt.core.UrlTag _jspx_th_c_005furl_005f5 = (org.apache.taglibs.standard.tag.rt.core.UrlTag) _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.get(org.apache.taglibs.standard.tag.rt.core.UrlTag.class);
    _jspx_th_c_005furl_005f5.setPageContext(_jspx_page_context);
    _jspx_th_c_005furl_005f5.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_sec_005fauthorize_005f0);
    // /WEB-INF/jsp/dashboard/../header.jsp(23,5) name = var type = java.lang.String reqTime = false required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f5.setVar("goalUrl");
    // /WEB-INF/jsp/dashboard/../header.jsp(23,5) name = value type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f5.setValue("/api/goal/list/");
    int _jspx_eval_c_005furl_005f5 = _jspx_th_c_005furl_005f5.doStartTag();
    if (_jspx_th_c_005furl_005f5.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f5);
      return true;
    }
    _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f5);
    return false;
  }

  private boolean _jspx_meth_sec_005fauthorize_005f1(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  sec:authorize
    org.springframework.security.taglibs.authz.JspAuthorizeTag _jspx_th_sec_005fauthorize_005f1 = (org.springframework.security.taglibs.authz.JspAuthorizeTag) _005fjspx_005ftagPool_005fsec_005fauthorize_0026_005fifAnyGranted.get(org.springframework.security.taglibs.authz.JspAuthorizeTag.class);
    _jspx_th_sec_005fauthorize_005f1.setPageContext(_jspx_page_context);
    _jspx_th_sec_005fauthorize_005f1.setParent(null);
    // /WEB-INF/jsp/dashboard/../header.jsp(30,2) name = ifAnyGranted type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_sec_005fauthorize_005f1.setIfAnyGranted("ROLE_STUDENT");
    int _jspx_eval_sec_005fauthorize_005f1 = _jspx_th_sec_005fauthorize_005f1.doStartTag();
    if (_jspx_eval_sec_005fauthorize_005f1 != javax.servlet.jsp.tagext.Tag.SKIP_BODY) {
      out.write("\n");
      out.write("\t\t\t");
      if (_jspx_meth_c_005furl_005f6(_jspx_th_sec_005fauthorize_005f1, _jspx_page_context))
        return true;
      out.write("\n");
      out.write("\t\t\t");
      if (_jspx_meth_c_005furl_005f7(_jspx_th_sec_005fauthorize_005f1, _jspx_page_context))
        return true;
      out.write("\n");
      out.write("\t\t\t\n");
      out.write("\t\t\t<li><a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${listUrl}", java.lang.String.class, (PageContext)_jspx_page_context, null, false));
      out.write("\">Lessons</a></li>\n");
      out.write("\t\t\t<li><a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${studentDashboardUrl}", java.lang.String.class, (PageContext)_jspx_page_context, null, false));
      out.write("\">Dashboard</a></li>\n");
      out.write("\t\t\t<li><a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${logoutUrl}", java.lang.String.class, (PageContext)_jspx_page_context, null, false));
      out.write("\">Logout</a></li>\n");
      out.write("\t\t");
    }
    if (_jspx_th_sec_005fauthorize_005f1.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fsec_005fauthorize_0026_005fifAnyGranted.reuse(_jspx_th_sec_005fauthorize_005f1);
      return true;
    }
    _005fjspx_005ftagPool_005fsec_005fauthorize_0026_005fifAnyGranted.reuse(_jspx_th_sec_005fauthorize_005f1);
    return false;
  }

  private boolean _jspx_meth_c_005furl_005f6(javax.servlet.jsp.tagext.JspTag _jspx_th_sec_005fauthorize_005f1, PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  c:url
    org.apache.taglibs.standard.tag.rt.core.UrlTag _jspx_th_c_005furl_005f6 = (org.apache.taglibs.standard.tag.rt.core.UrlTag) _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.get(org.apache.taglibs.standard.tag.rt.core.UrlTag.class);
    _jspx_th_c_005furl_005f6.setPageContext(_jspx_page_context);
    _jspx_th_c_005furl_005f6.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_sec_005fauthorize_005f1);
    // /WEB-INF/jsp/dashboard/../header.jsp(31,3) name = var type = java.lang.String reqTime = false required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f6.setVar("listUrl");
    // /WEB-INF/jsp/dashboard/../header.jsp(31,3) name = value type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f6.setValue("/api/quizzes/list");
    int _jspx_eval_c_005furl_005f6 = _jspx_th_c_005furl_005f6.doStartTag();
    if (_jspx_th_c_005furl_005f6.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f6);
      return true;
    }
    _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f6);
    return false;
  }

  private boolean _jspx_meth_c_005furl_005f7(javax.servlet.jsp.tagext.JspTag _jspx_th_sec_005fauthorize_005f1, PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  c:url
    org.apache.taglibs.standard.tag.rt.core.UrlTag _jspx_th_c_005furl_005f7 = (org.apache.taglibs.standard.tag.rt.core.UrlTag) _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.get(org.apache.taglibs.standard.tag.rt.core.UrlTag.class);
    _jspx_th_c_005furl_005f7.setPageContext(_jspx_page_context);
    _jspx_th_c_005furl_005f7.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_sec_005fauthorize_005f1);
    // /WEB-INF/jsp/dashboard/../header.jsp(32,3) name = var type = java.lang.String reqTime = false required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f7.setVar("studentDashboardUrl");
    // /WEB-INF/jsp/dashboard/../header.jsp(32,3) name = value type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f7.setValue("/api/students/dashboard");
    int _jspx_eval_c_005furl_005f7 = _jspx_th_c_005furl_005f7.doStartTag();
    if (_jspx_th_c_005furl_005f7.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f7);
      return true;
    }
    _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f7);
    return false;
  }

  private boolean _jspx_meth_sec_005fauthorize_005f2(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  sec:authorize
    org.springframework.security.taglibs.authz.JspAuthorizeTag _jspx_th_sec_005fauthorize_005f2 = (org.springframework.security.taglibs.authz.JspAuthorizeTag) _005fjspx_005ftagPool_005fsec_005fauthorize_0026_005fifAnyGranted.get(org.springframework.security.taglibs.authz.JspAuthorizeTag.class);
    _jspx_th_sec_005fauthorize_005f2.setPageContext(_jspx_page_context);
    _jspx_th_sec_005fauthorize_005f2.setParent(null);
    // /WEB-INF/jsp/dashboard/../header.jsp(39,13) name = ifAnyGranted type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_sec_005fauthorize_005f2.setIfAnyGranted("ROLE_USER");
    int _jspx_eval_sec_005fauthorize_005f2 = _jspx_th_sec_005fauthorize_005f2.doStartTag();
    if (_jspx_eval_sec_005fauthorize_005f2 != javax.servlet.jsp.tagext.Tag.SKIP_BODY) {
      out.write("\n");
      out.write("\t\t\t");
      if (_jspx_meth_c_005furl_005f8(_jspx_th_sec_005fauthorize_005f2, _jspx_page_context))
        return true;
      out.write("\n");
      out.write("\t        <li><a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${createQuizUrl}", java.lang.String.class, (PageContext)_jspx_page_context, null, false));
      out.write("\">Create Lesson</a></li>\n");
      out.write("\t        ");
      if (_jspx_meth_c_005furl_005f9(_jspx_th_sec_005fauthorize_005f2, _jspx_page_context))
        return true;
      out.write("\n");
      out.write("\t        <li><a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${homeUrl}", java.lang.String.class, (PageContext)_jspx_page_context, null, false));
      out.write("\">Edit Lessons and Drafts</a></li>\n");
      out.write("\t        <li><a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${logoutUrl}", java.lang.String.class, (PageContext)_jspx_page_context, null, false));
      out.write("\">Logout</a></li>\n");
      out.write("\t\t");
    }
    if (_jspx_th_sec_005fauthorize_005f2.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fsec_005fauthorize_0026_005fifAnyGranted.reuse(_jspx_th_sec_005fauthorize_005f2);
      return true;
    }
    _005fjspx_005ftagPool_005fsec_005fauthorize_0026_005fifAnyGranted.reuse(_jspx_th_sec_005fauthorize_005f2);
    return false;
  }

  private boolean _jspx_meth_c_005furl_005f8(javax.servlet.jsp.tagext.JspTag _jspx_th_sec_005fauthorize_005f2, PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  c:url
    org.apache.taglibs.standard.tag.rt.core.UrlTag _jspx_th_c_005furl_005f8 = (org.apache.taglibs.standard.tag.rt.core.UrlTag) _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.get(org.apache.taglibs.standard.tag.rt.core.UrlTag.class);
    _jspx_th_c_005furl_005f8.setPageContext(_jspx_page_context);
    _jspx_th_c_005furl_005f8.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_sec_005fauthorize_005f2);
    // /WEB-INF/jsp/dashboard/../header.jsp(40,3) name = var type = java.lang.String reqTime = false required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f8.setVar("createQuizUrl");
    // /WEB-INF/jsp/dashboard/../header.jsp(40,3) name = value type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f8.setValue("/api/lessonEdit/start");
    int _jspx_eval_c_005furl_005f8 = _jspx_th_c_005furl_005f8.doStartTag();
    if (_jspx_th_c_005furl_005f8.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f8);
      return true;
    }
    _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f8);
    return false;
  }

  private boolean _jspx_meth_c_005furl_005f9(javax.servlet.jsp.tagext.JspTag _jspx_th_sec_005fauthorize_005f2, PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  c:url
    org.apache.taglibs.standard.tag.rt.core.UrlTag _jspx_th_c_005furl_005f9 = (org.apache.taglibs.standard.tag.rt.core.UrlTag) _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.get(org.apache.taglibs.standard.tag.rt.core.UrlTag.class);
    _jspx_th_c_005furl_005f9.setPageContext(_jspx_page_context);
    _jspx_th_c_005furl_005f9.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_sec_005fauthorize_005f2);
    // /WEB-INF/jsp/dashboard/../header.jsp(42,9) name = var type = java.lang.String reqTime = false required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f9.setVar("homeUrl");
    // /WEB-INF/jsp/dashboard/../header.jsp(42,9) name = value type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f9.setValue("/api/quizzes/list");
    int _jspx_eval_c_005furl_005f9 = _jspx_th_c_005furl_005f9.doStartTag();
    if (_jspx_th_c_005furl_005f9.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f9);
      return true;
    }
    _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f9);
    return false;
  }

  private boolean _jspx_meth_c_005furl_005f10(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  c:url
    org.apache.taglibs.standard.tag.rt.core.UrlTag _jspx_th_c_005furl_005f10 = (org.apache.taglibs.standard.tag.rt.core.UrlTag) _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.get(org.apache.taglibs.standard.tag.rt.core.UrlTag.class);
    _jspx_th_c_005furl_005f10.setPageContext(_jspx_page_context);
    _jspx_th_c_005furl_005f10.setParent(null);
    // /WEB-INF/jsp/dashboard/dashboard.jsp(26,0) name = var type = java.lang.String reqTime = false required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f10.setVar("saveUrl");
    // /WEB-INF/jsp/dashboard/dashboard.jsp(26,0) name = value type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f10.setValue("/api/dashboard/");
    int _jspx_eval_c_005furl_005f10 = _jspx_th_c_005furl_005f10.doStartTag();
    if (_jspx_th_c_005furl_005f10.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f10);
      return true;
    }
    _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f10);
    return false;
  }

  private boolean _jspx_meth_c_005furl_005f11(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  c:url
    org.apache.taglibs.standard.tag.rt.core.UrlTag _jspx_th_c_005furl_005f11 = (org.apache.taglibs.standard.tag.rt.core.UrlTag) _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.get(org.apache.taglibs.standard.tag.rt.core.UrlTag.class);
    _jspx_th_c_005furl_005f11.setPageContext(_jspx_page_context);
    _jspx_th_c_005furl_005f11.setParent(null);
    // /WEB-INF/jsp/dashboard/dashboard.jsp(27,0) name = var type = java.lang.String reqTime = false required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f11.setVar("ajaxPicksGroups");
    // /WEB-INF/jsp/dashboard/dashboard.jsp(27,0) name = value type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f11.setValue("/api/dashboard/groups/");
    int _jspx_eval_c_005furl_005f11 = _jspx_th_c_005furl_005f11.doStartTag();
    if (_jspx_th_c_005furl_005f11.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f11);
      return true;
    }
    _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f11);
    return false;
  }

  private boolean _jspx_meth_form_005fform_005f0(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  form:form
    org.springframework.web.servlet.tags.form.FormTag _jspx_th_form_005fform_005f0 = (org.springframework.web.servlet.tags.form.FormTag) _005fjspx_005ftagPool_005fform_005fform_0026_005fmodelAttribute_005fmethod_005fid_005fclass_005faction.get(org.springframework.web.servlet.tags.form.FormTag.class);
    _jspx_th_form_005fform_005f0.setPageContext(_jspx_page_context);
    _jspx_th_form_005fform_005f0.setParent(null);
    // /WEB-INF/jsp/dashboard/dashboard.jsp(29,0) name = modelAttribute type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_form_005fform_005f0.setModelAttribute("dashboardBean");
    // /WEB-INF/jsp/dashboard/dashboard.jsp(29,0) name = method type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_form_005fform_005f0.setMethod("POST");
    // /WEB-INF/jsp/dashboard/dashboard.jsp(29,0) name = action type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_form_005fform_005f0.setAction((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${saveUrl}", java.lang.String.class, (PageContext)_jspx_page_context, null, false));
    // /WEB-INF/jsp/dashboard/dashboard.jsp(29,0) null
    _jspx_th_form_005fform_005f0.setDynamicAttribute(null, "class", new String("niceForm"));
    // /WEB-INF/jsp/dashboard/dashboard.jsp(29,0) name = id type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_form_005fform_005f0.setId("idFormDashboard");
    int[] _jspx_push_body_count_form_005fform_005f0 = new int[] { 0 };
    try {
      int _jspx_eval_form_005fform_005f0 = _jspx_th_form_005fform_005f0.doStartTag();
      if (_jspx_eval_form_005fform_005f0 != javax.servlet.jsp.tagext.Tag.SKIP_BODY) {
        do {
          out.write('\n');
          out.write('	');
          if (_jspx_meth_form_005fhidden_005f0(_jspx_th_form_005fform_005f0, _jspx_page_context, _jspx_push_body_count_form_005fform_005f0))
            return true;
          out.write('\n');
          out.write('	');
          if (_jspx_meth_form_005fhidden_005f1(_jspx_th_form_005fform_005f0, _jspx_page_context, _jspx_push_body_count_form_005fform_005f0))
            return true;
          out.write('\n');
          out.write('	');
          if (_jspx_meth_form_005fhidden_005f2(_jspx_th_form_005fform_005f0, _jspx_page_context, _jspx_push_body_count_form_005fform_005f0))
            return true;
          out.write("\n");
          out.write("\t\n");
          out.write("\t");
          if (_jspx_meth_form_005fselect_005f0(_jspx_th_form_005fform_005f0, _jspx_page_context, _jspx_push_body_count_form_005fform_005f0))
            return true;
          out.write("&nbsp;&nbsp;\n");
          out.write("\t");
          if (_jspx_meth_form_005fselect_005f1(_jspx_th_form_005fform_005f0, _jspx_page_context, _jspx_push_body_count_form_005fform_005f0))
            return true;
          out.write("&nbsp;&nbsp;\n");
          out.write(" \t\n");
          out.write("\t");
          if (_jspx_meth_form_005fselect_005f2(_jspx_th_form_005fform_005f0, _jspx_page_context, _jspx_push_body_count_form_005fform_005f0))
            return true;
          out.write("&nbsp;&nbsp;\n");
          out.write(" \t\n");
          out.write("\t\n");
          out.write("\t<br></br>\n");
          out.write("\t\n");
          out.write("\t<select id=\"lessonsGoals\">\n");
          out.write("\t\t<option value=\"2\">This Week's Lessons</option>\n");
          out.write("\t\t<option value=\"1\">Goals</option>\n");
          out.write("\t</select>\n");
          out.write("\t\n");
          out.write("\t<br></br>\n");
          out.write("\t\n");
          out.write("\t<div id=\"loadedContent\">\n");
          out.write("\t\t<table class=\"styledTable\">\n");
          out.write("\t\t<tbody>\n");
          out.write("\t\t");
          if (_jspx_meth_c_005fforEach_005f0(_jspx_th_form_005fform_005f0, _jspx_page_context, _jspx_push_body_count_form_005fform_005f0))
            return true;
          out.write("\n");
          out.write("\t\t</tbody>\n");
          out.write("\t\t</table>\n");
          out.write("\t</div>\n");
          out.write("\t\n");
          out.write("\t<br>\n");
          out.write("\n");
          out.write("\n");
          out.write("\t<br>\n");
          out.write("\t<div class=\"controls\" id=\"controls\">\n");
          out.write("\t <input type=\"button\" name=\"add\" value=\"See Result\" class=\"button blue left\" onclick=\"javascript:loadDashboard();\"/> \n");
          out.write("\t <input type=\"button\" name=\"reset\" value=\"Reset Groups\" class=\"button blue right\" onclick=\"javascript:resetGroups();\"/> \n");
          out.write("\t</div>\n");
          out.write("\t\n");
          out.write("\t\n");
          out.write("<br>\n");
          out.write("<div id=\"cellColorDiv\" style=\"display:none\">\n");
          out.write("\t<table>\n");
          out.write("\t\t<tr>\n");
          out.write("\t\t\t<td>");
          if (_jspx_meth_form_005fcheckbox_005f1(_jspx_th_form_005fform_005f0, _jspx_page_context, _jspx_push_body_count_form_005fform_005f0))
            return true;
          out.write("</td>\n");
          out.write("\t\t\t<td nowrap=\"nowrap\"> <label for=\"cellColor1\">Color Code Each Column</label></td>\n");
          out.write("\t\t</tr>\n");
          out.write("\t</table>\n");
          out.write("</div>\n");
          out.write("\n");
          int evalDoAfterBody = _jspx_th_form_005fform_005f0.doAfterBody();
          if (evalDoAfterBody != javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN)
            break;
        } while (true);
      }
      if (_jspx_th_form_005fform_005f0.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } catch (Throwable _jspx_exception) {
      while (_jspx_push_body_count_form_005fform_005f0[0]-- > 0)
        out = _jspx_page_context.popBody();
      _jspx_th_form_005fform_005f0.doCatch(_jspx_exception);
    } finally {
      _jspx_th_form_005fform_005f0.doFinally();
      _005fjspx_005ftagPool_005fform_005fform_0026_005fmodelAttribute_005fmethod_005fid_005fclass_005faction.reuse(_jspx_th_form_005fform_005f0);
    }
    return false;
  }

  private boolean _jspx_meth_form_005fhidden_005f0(javax.servlet.jsp.tagext.JspTag _jspx_th_form_005fform_005f0, PageContext _jspx_page_context, int[] _jspx_push_body_count_form_005fform_005f0)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  form:hidden
    org.springframework.web.servlet.tags.form.HiddenInputTag _jspx_th_form_005fhidden_005f0 = (org.springframework.web.servlet.tags.form.HiddenInputTag) _005fjspx_005ftagPool_005fform_005fhidden_0026_005fpath_005fnobody.get(org.springframework.web.servlet.tags.form.HiddenInputTag.class);
    _jspx_th_form_005fhidden_005f0.setPageContext(_jspx_page_context);
    _jspx_th_form_005fhidden_005f0.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_form_005fform_005f0);
    // /WEB-INF/jsp/dashboard/dashboard.jsp(30,1) name = path type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_form_005fhidden_005f0.setPath("excludedStudentIds");
    int[] _jspx_push_body_count_form_005fhidden_005f0 = new int[] { 0 };
    try {
      int _jspx_eval_form_005fhidden_005f0 = _jspx_th_form_005fhidden_005f0.doStartTag();
      if (_jspx_th_form_005fhidden_005f0.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } catch (Throwable _jspx_exception) {
      while (_jspx_push_body_count_form_005fhidden_005f0[0]-- > 0)
        out = _jspx_page_context.popBody();
      _jspx_th_form_005fhidden_005f0.doCatch(_jspx_exception);
    } finally {
      _jspx_th_form_005fhidden_005f0.doFinally();
      _005fjspx_005ftagPool_005fform_005fhidden_0026_005fpath_005fnobody.reuse(_jspx_th_form_005fhidden_005f0);
    }
    return false;
  }

  private boolean _jspx_meth_form_005fhidden_005f1(javax.servlet.jsp.tagext.JspTag _jspx_th_form_005fform_005f0, PageContext _jspx_page_context, int[] _jspx_push_body_count_form_005fform_005f0)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  form:hidden
    org.springframework.web.servlet.tags.form.HiddenInputTag _jspx_th_form_005fhidden_005f1 = (org.springframework.web.servlet.tags.form.HiddenInputTag) _005fjspx_005ftagPool_005fform_005fhidden_0026_005fpath_005fnobody.get(org.springframework.web.servlet.tags.form.HiddenInputTag.class);
    _jspx_th_form_005fhidden_005f1.setPageContext(_jspx_page_context);
    _jspx_th_form_005fhidden_005f1.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_form_005fform_005f0);
    // /WEB-INF/jsp/dashboard/dashboard.jsp(31,1) name = path type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_form_005fhidden_005f1.setPath("sortByColumn");
    int[] _jspx_push_body_count_form_005fhidden_005f1 = new int[] { 0 };
    try {
      int _jspx_eval_form_005fhidden_005f1 = _jspx_th_form_005fhidden_005f1.doStartTag();
      if (_jspx_th_form_005fhidden_005f1.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } catch (Throwable _jspx_exception) {
      while (_jspx_push_body_count_form_005fhidden_005f1[0]-- > 0)
        out = _jspx_page_context.popBody();
      _jspx_th_form_005fhidden_005f1.doCatch(_jspx_exception);
    } finally {
      _jspx_th_form_005fhidden_005f1.doFinally();
      _005fjspx_005ftagPool_005fform_005fhidden_0026_005fpath_005fnobody.reuse(_jspx_th_form_005fhidden_005f1);
    }
    return false;
  }

  private boolean _jspx_meth_form_005fhidden_005f2(javax.servlet.jsp.tagext.JspTag _jspx_th_form_005fform_005f0, PageContext _jspx_page_context, int[] _jspx_push_body_count_form_005fform_005f0)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  form:hidden
    org.springframework.web.servlet.tags.form.HiddenInputTag _jspx_th_form_005fhidden_005f2 = (org.springframework.web.servlet.tags.form.HiddenInputTag) _005fjspx_005ftagPool_005fform_005fhidden_0026_005fpath_005fnobody.get(org.springframework.web.servlet.tags.form.HiddenInputTag.class);
    _jspx_th_form_005fhidden_005f2.setPageContext(_jspx_page_context);
    _jspx_th_form_005fhidden_005f2.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_form_005fform_005f0);
    // /WEB-INF/jsp/dashboard/dashboard.jsp(32,1) name = path type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_form_005fhidden_005f2.setPath("sortDirection");
    int[] _jspx_push_body_count_form_005fhidden_005f2 = new int[] { 0 };
    try {
      int _jspx_eval_form_005fhidden_005f2 = _jspx_th_form_005fhidden_005f2.doStartTag();
      if (_jspx_th_form_005fhidden_005f2.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } catch (Throwable _jspx_exception) {
      while (_jspx_push_body_count_form_005fhidden_005f2[0]-- > 0)
        out = _jspx_page_context.popBody();
      _jspx_th_form_005fhidden_005f2.doCatch(_jspx_exception);
    } finally {
      _jspx_th_form_005fhidden_005f2.doFinally();
      _005fjspx_005ftagPool_005fform_005fhidden_0026_005fpath_005fnobody.reuse(_jspx_th_form_005fhidden_005f2);
    }
    return false;
  }

  private boolean _jspx_meth_form_005fselect_005f0(javax.servlet.jsp.tagext.JspTag _jspx_th_form_005fform_005f0, PageContext _jspx_page_context, int[] _jspx_push_body_count_form_005fform_005f0)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  form:select
    org.springframework.web.servlet.tags.form.SelectTag _jspx_th_form_005fselect_005f0 = (org.springframework.web.servlet.tags.form.SelectTag) _005fjspx_005ftagPool_005fform_005fselect_0026_005fpath_005fcssStyle.get(org.springframework.web.servlet.tags.form.SelectTag.class);
    _jspx_th_form_005fselect_005f0.setPageContext(_jspx_page_context);
    _jspx_th_form_005fselect_005f0.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_form_005fform_005f0);
    // /WEB-INF/jsp/dashboard/dashboard.jsp(34,1) name = path type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_form_005fselect_005f0.setPath("classId");
    // /WEB-INF/jsp/dashboard/dashboard.jsp(34,1) name = cssStyle type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_form_005fselect_005f0.setCssStyle("width: 130px");
    int[] _jspx_push_body_count_form_005fselect_005f0 = new int[] { 0 };
    try {
      int _jspx_eval_form_005fselect_005f0 = _jspx_th_form_005fselect_005f0.doStartTag();
      if (_jspx_eval_form_005fselect_005f0 != javax.servlet.jsp.tagext.Tag.SKIP_BODY) {
        do {
          out.write("\n");
          out.write("   \t\t");
          if (_jspx_meth_form_005foptions_005f0(_jspx_th_form_005fselect_005f0, _jspx_page_context, _jspx_push_body_count_form_005fselect_005f0))
            return true;
          out.write('\n');
          out.write('	');
          int evalDoAfterBody = _jspx_th_form_005fselect_005f0.doAfterBody();
          if (evalDoAfterBody != javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN)
            break;
        } while (true);
      }
      if (_jspx_th_form_005fselect_005f0.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } catch (Throwable _jspx_exception) {
      while (_jspx_push_body_count_form_005fselect_005f0[0]-- > 0)
        out = _jspx_page_context.popBody();
      _jspx_th_form_005fselect_005f0.doCatch(_jspx_exception);
    } finally {
      _jspx_th_form_005fselect_005f0.doFinally();
      _005fjspx_005ftagPool_005fform_005fselect_0026_005fpath_005fcssStyle.reuse(_jspx_th_form_005fselect_005f0);
    }
    return false;
  }

  private boolean _jspx_meth_form_005foptions_005f0(javax.servlet.jsp.tagext.JspTag _jspx_th_form_005fselect_005f0, PageContext _jspx_page_context, int[] _jspx_push_body_count_form_005fselect_005f0)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  form:options
    org.springframework.web.servlet.tags.form.OptionsTag _jspx_th_form_005foptions_005f0 = (org.springframework.web.servlet.tags.form.OptionsTag) _005fjspx_005ftagPool_005fform_005foptions_0026_005fitems_005fnobody.get(org.springframework.web.servlet.tags.form.OptionsTag.class);
    _jspx_th_form_005foptions_005f0.setPageContext(_jspx_page_context);
    _jspx_th_form_005foptions_005f0.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_form_005fselect_005f0);
    // /WEB-INF/jsp/dashboard/dashboard.jsp(35,5) name = items type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_form_005foptions_005f0.setItems((java.lang.Object) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${classes}", java.lang.Object.class, (PageContext)_jspx_page_context, null, false));
    int[] _jspx_push_body_count_form_005foptions_005f0 = new int[] { 0 };
    try {
      int _jspx_eval_form_005foptions_005f0 = _jspx_th_form_005foptions_005f0.doStartTag();
      if (_jspx_th_form_005foptions_005f0.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } catch (Throwable _jspx_exception) {
      while (_jspx_push_body_count_form_005foptions_005f0[0]-- > 0)
        out = _jspx_page_context.popBody();
      _jspx_th_form_005foptions_005f0.doCatch(_jspx_exception);
    } finally {
      _jspx_th_form_005foptions_005f0.doFinally();
      _005fjspx_005ftagPool_005fform_005foptions_0026_005fitems_005fnobody.reuse(_jspx_th_form_005foptions_005f0);
    }
    return false;
  }

  private boolean _jspx_meth_form_005fselect_005f1(javax.servlet.jsp.tagext.JspTag _jspx_th_form_005fform_005f0, PageContext _jspx_page_context, int[] _jspx_push_body_count_form_005fform_005f0)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  form:select
    org.springframework.web.servlet.tags.form.SelectTag _jspx_th_form_005fselect_005f1 = (org.springframework.web.servlet.tags.form.SelectTag) _005fjspx_005ftagPool_005fform_005fselect_0026_005fpath_005fcssStyle.get(org.springframework.web.servlet.tags.form.SelectTag.class);
    _jspx_th_form_005fselect_005f1.setPageContext(_jspx_page_context);
    _jspx_th_form_005fselect_005f1.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_form_005fform_005f0);
    // /WEB-INF/jsp/dashboard/dashboard.jsp(37,1) name = path type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_form_005fselect_005f1.setPath("subjectId");
    // /WEB-INF/jsp/dashboard/dashboard.jsp(37,1) name = cssStyle type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_form_005fselect_005f1.setCssStyle("width: 130px");
    int[] _jspx_push_body_count_form_005fselect_005f1 = new int[] { 0 };
    try {
      int _jspx_eval_form_005fselect_005f1 = _jspx_th_form_005fselect_005f1.doStartTag();
      if (_jspx_eval_form_005fselect_005f1 != javax.servlet.jsp.tagext.Tag.SKIP_BODY) {
        do {
          out.write("\n");
          out.write("   \t\t");
          if (_jspx_meth_form_005foptions_005f1(_jspx_th_form_005fselect_005f1, _jspx_page_context, _jspx_push_body_count_form_005fselect_005f1))
            return true;
          out.write('\n');
          out.write('	');
          int evalDoAfterBody = _jspx_th_form_005fselect_005f1.doAfterBody();
          if (evalDoAfterBody != javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN)
            break;
        } while (true);
      }
      if (_jspx_th_form_005fselect_005f1.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } catch (Throwable _jspx_exception) {
      while (_jspx_push_body_count_form_005fselect_005f1[0]-- > 0)
        out = _jspx_page_context.popBody();
      _jspx_th_form_005fselect_005f1.doCatch(_jspx_exception);
    } finally {
      _jspx_th_form_005fselect_005f1.doFinally();
      _005fjspx_005ftagPool_005fform_005fselect_0026_005fpath_005fcssStyle.reuse(_jspx_th_form_005fselect_005f1);
    }
    return false;
  }

  private boolean _jspx_meth_form_005foptions_005f1(javax.servlet.jsp.tagext.JspTag _jspx_th_form_005fselect_005f1, PageContext _jspx_page_context, int[] _jspx_push_body_count_form_005fselect_005f1)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  form:options
    org.springframework.web.servlet.tags.form.OptionsTag _jspx_th_form_005foptions_005f1 = (org.springframework.web.servlet.tags.form.OptionsTag) _005fjspx_005ftagPool_005fform_005foptions_0026_005fitems_005fnobody.get(org.springframework.web.servlet.tags.form.OptionsTag.class);
    _jspx_th_form_005foptions_005f1.setPageContext(_jspx_page_context);
    _jspx_th_form_005foptions_005f1.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_form_005fselect_005f1);
    // /WEB-INF/jsp/dashboard/dashboard.jsp(38,5) name = items type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_form_005foptions_005f1.setItems((java.lang.Object) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${subject}", java.lang.Object.class, (PageContext)_jspx_page_context, null, false));
    int[] _jspx_push_body_count_form_005foptions_005f1 = new int[] { 0 };
    try {
      int _jspx_eval_form_005foptions_005f1 = _jspx_th_form_005foptions_005f1.doStartTag();
      if (_jspx_th_form_005foptions_005f1.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } catch (Throwable _jspx_exception) {
      while (_jspx_push_body_count_form_005foptions_005f1[0]-- > 0)
        out = _jspx_page_context.popBody();
      _jspx_th_form_005foptions_005f1.doCatch(_jspx_exception);
    } finally {
      _jspx_th_form_005foptions_005f1.doFinally();
      _005fjspx_005ftagPool_005fform_005foptions_0026_005fitems_005fnobody.reuse(_jspx_th_form_005foptions_005f1);
    }
    return false;
  }

  private boolean _jspx_meth_form_005fselect_005f2(javax.servlet.jsp.tagext.JspTag _jspx_th_form_005fform_005f0, PageContext _jspx_page_context, int[] _jspx_push_body_count_form_005fform_005f0)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  form:select
    org.springframework.web.servlet.tags.form.SelectTag _jspx_th_form_005fselect_005f2 = (org.springframework.web.servlet.tags.form.SelectTag) _005fjspx_005ftagPool_005fform_005fselect_0026_005fpath_005fcssStyle.get(org.springframework.web.servlet.tags.form.SelectTag.class);
    _jspx_th_form_005fselect_005f2.setPageContext(_jspx_page_context);
    _jspx_th_form_005fselect_005f2.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_form_005fform_005f0);
    // /WEB-INF/jsp/dashboard/dashboard.jsp(41,1) name = path type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_form_005fselect_005f2.setPath("groupId");
    // /WEB-INF/jsp/dashboard/dashboard.jsp(41,1) name = cssStyle type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_form_005fselect_005f2.setCssStyle("width: 130px");
    int[] _jspx_push_body_count_form_005fselect_005f2 = new int[] { 0 };
    try {
      int _jspx_eval_form_005fselect_005f2 = _jspx_th_form_005fselect_005f2.doStartTag();
      if (_jspx_eval_form_005fselect_005f2 != javax.servlet.jsp.tagext.Tag.SKIP_BODY) {
        do {
          out.write("\n");
          out.write("   \t\t");
          if (_jspx_meth_form_005foptions_005f2(_jspx_th_form_005fselect_005f2, _jspx_page_context, _jspx_push_body_count_form_005fselect_005f2))
            return true;
          out.write('\n');
          out.write('	');
          int evalDoAfterBody = _jspx_th_form_005fselect_005f2.doAfterBody();
          if (evalDoAfterBody != javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN)
            break;
        } while (true);
      }
      if (_jspx_th_form_005fselect_005f2.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } catch (Throwable _jspx_exception) {
      while (_jspx_push_body_count_form_005fselect_005f2[0]-- > 0)
        out = _jspx_page_context.popBody();
      _jspx_th_form_005fselect_005f2.doCatch(_jspx_exception);
    } finally {
      _jspx_th_form_005fselect_005f2.doFinally();
      _005fjspx_005ftagPool_005fform_005fselect_0026_005fpath_005fcssStyle.reuse(_jspx_th_form_005fselect_005f2);
    }
    return false;
  }

  private boolean _jspx_meth_form_005foptions_005f2(javax.servlet.jsp.tagext.JspTag _jspx_th_form_005fselect_005f2, PageContext _jspx_page_context, int[] _jspx_push_body_count_form_005fselect_005f2)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  form:options
    org.springframework.web.servlet.tags.form.OptionsTag _jspx_th_form_005foptions_005f2 = (org.springframework.web.servlet.tags.form.OptionsTag) _005fjspx_005ftagPool_005fform_005foptions_0026_005fitems_005fnobody.get(org.springframework.web.servlet.tags.form.OptionsTag.class);
    _jspx_th_form_005foptions_005f2.setPageContext(_jspx_page_context);
    _jspx_th_form_005foptions_005f2.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_form_005fselect_005f2);
    // /WEB-INF/jsp/dashboard/dashboard.jsp(42,5) name = items type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_form_005foptions_005f2.setItems((java.lang.Object) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${groups}", java.lang.Object.class, (PageContext)_jspx_page_context, null, false));
    int[] _jspx_push_body_count_form_005foptions_005f2 = new int[] { 0 };
    try {
      int _jspx_eval_form_005foptions_005f2 = _jspx_th_form_005foptions_005f2.doStartTag();
      if (_jspx_th_form_005foptions_005f2.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } catch (Throwable _jspx_exception) {
      while (_jspx_push_body_count_form_005foptions_005f2[0]-- > 0)
        out = _jspx_page_context.popBody();
      _jspx_th_form_005foptions_005f2.doCatch(_jspx_exception);
    } finally {
      _jspx_th_form_005foptions_005f2.doFinally();
      _005fjspx_005ftagPool_005fform_005foptions_0026_005fitems_005fnobody.reuse(_jspx_th_form_005foptions_005f2);
    }
    return false;
  }

  private boolean _jspx_meth_c_005fforEach_005f0(javax.servlet.jsp.tagext.JspTag _jspx_th_form_005fform_005f0, PageContext _jspx_page_context, int[] _jspx_push_body_count_form_005fform_005f0)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  c:forEach
    org.apache.taglibs.standard.tag.rt.core.ForEachTag _jspx_th_c_005fforEach_005f0 = (org.apache.taglibs.standard.tag.rt.core.ForEachTag) _005fjspx_005ftagPool_005fc_005fforEach_0026_005fvarStatus_005fvar_005fitems.get(org.apache.taglibs.standard.tag.rt.core.ForEachTag.class);
    _jspx_th_c_005fforEach_005f0.setPageContext(_jspx_page_context);
    _jspx_th_c_005fforEach_005f0.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_form_005fform_005f0);
    // /WEB-INF/jsp/dashboard/dashboard.jsp(58,2) name = items type = java.lang.Object reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005fforEach_005f0.setItems((java.lang.Object) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${dashboardBean.assignmentLessons}", java.lang.Object.class, (PageContext)_jspx_page_context, null, false));
    // /WEB-INF/jsp/dashboard/dashboard.jsp(58,2) name = var type = java.lang.String reqTime = false required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005fforEach_005f0.setVar("al");
    // /WEB-INF/jsp/dashboard/dashboard.jsp(58,2) name = varStatus type = java.lang.String reqTime = false required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005fforEach_005f0.setVarStatus("current");
    int[] _jspx_push_body_count_c_005fforEach_005f0 = new int[] { 0 };
    try {
      int _jspx_eval_c_005fforEach_005f0 = _jspx_th_c_005fforEach_005f0.doStartTag();
      if (_jspx_eval_c_005fforEach_005f0 != javax.servlet.jsp.tagext.Tag.SKIP_BODY) {
        do {
          out.write("\n");
          out.write("\t\t\t<tr class=\"");
          if (_jspx_meth_c_005fif_005f0(_jspx_th_c_005fforEach_005f0, _jspx_page_context, _jspx_push_body_count_c_005fforEach_005f0))
            return true;
          out.write("\">\n");
          out.write("\t\t\t\t<td>");
          if (_jspx_meth_form_005fcheckbox_005f0(_jspx_th_c_005fforEach_005f0, _jspx_page_context, _jspx_push_body_count_c_005fforEach_005f0))
            return true;
          out.write("</td>\n");
          out.write("\t\t\t\t<td>");
          if (_jspx_meth_c_005fout_005f0(_jspx_th_c_005fforEach_005f0, _jspx_page_context, _jspx_push_body_count_c_005fforEach_005f0))
            return true;
          out.write(' ');
          if (_jspx_meth_fmt_005fformatDate_005f0(_jspx_th_c_005fforEach_005f0, _jspx_page_context, _jspx_push_body_count_c_005fforEach_005f0))
            return true;
          out.write("</td>\n");
          out.write("\t\t\t</tr>\n");
          out.write("\t\t");
          int evalDoAfterBody = _jspx_th_c_005fforEach_005f0.doAfterBody();
          if (evalDoAfterBody != javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN)
            break;
        } while (true);
      }
      if (_jspx_th_c_005fforEach_005f0.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } catch (Throwable _jspx_exception) {
      while (_jspx_push_body_count_c_005fforEach_005f0[0]-- > 0)
        out = _jspx_page_context.popBody();
      _jspx_th_c_005fforEach_005f0.doCatch(_jspx_exception);
    } finally {
      _jspx_th_c_005fforEach_005f0.doFinally();
      _005fjspx_005ftagPool_005fc_005fforEach_0026_005fvarStatus_005fvar_005fitems.reuse(_jspx_th_c_005fforEach_005f0);
    }
    return false;
  }

  private boolean _jspx_meth_c_005fif_005f0(javax.servlet.jsp.tagext.JspTag _jspx_th_c_005fforEach_005f0, PageContext _jspx_page_context, int[] _jspx_push_body_count_c_005fforEach_005f0)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  c:if
    org.apache.taglibs.standard.tag.rt.core.IfTag _jspx_th_c_005fif_005f0 = (org.apache.taglibs.standard.tag.rt.core.IfTag) _005fjspx_005ftagPool_005fc_005fif_0026_005ftest.get(org.apache.taglibs.standard.tag.rt.core.IfTag.class);
    _jspx_th_c_005fif_005f0.setPageContext(_jspx_page_context);
    _jspx_th_c_005fif_005f0.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_c_005fforEach_005f0);
    // /WEB-INF/jsp/dashboard/dashboard.jsp(59,14) name = test type = boolean reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005fif_005f0.setTest(((java.lang.Boolean) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${current.index % 2 != 0}", java.lang.Boolean.class, (PageContext)_jspx_page_context, null, false)).booleanValue());
    int _jspx_eval_c_005fif_005f0 = _jspx_th_c_005fif_005f0.doStartTag();
    if (_jspx_eval_c_005fif_005f0 != javax.servlet.jsp.tagext.Tag.SKIP_BODY) {
      do {
        out.write("even");
        int evalDoAfterBody = _jspx_th_c_005fif_005f0.doAfterBody();
        if (evalDoAfterBody != javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN)
          break;
      } while (true);
    }
    if (_jspx_th_c_005fif_005f0.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fc_005fif_0026_005ftest.reuse(_jspx_th_c_005fif_005f0);
      return true;
    }
    _005fjspx_005ftagPool_005fc_005fif_0026_005ftest.reuse(_jspx_th_c_005fif_005f0);
    return false;
  }

  private boolean _jspx_meth_form_005fcheckbox_005f0(javax.servlet.jsp.tagext.JspTag _jspx_th_c_005fforEach_005f0, PageContext _jspx_page_context, int[] _jspx_push_body_count_c_005fforEach_005f0)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  form:checkbox
    org.springframework.web.servlet.tags.form.CheckboxTag _jspx_th_form_005fcheckbox_005f0 = (org.springframework.web.servlet.tags.form.CheckboxTag) _005fjspx_005ftagPool_005fform_005fcheckbox_0026_005fvalue_005fpath_005fnobody.get(org.springframework.web.servlet.tags.form.CheckboxTag.class);
    _jspx_th_form_005fcheckbox_005f0.setPageContext(_jspx_page_context);
    _jspx_th_form_005fcheckbox_005f0.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_c_005fforEach_005f0);
    // /WEB-INF/jsp/dashboard/dashboard.jsp(60,8) name = path type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_form_005fcheckbox_005f0.setPath("assignmentLessonIds");
    // /WEB-INF/jsp/dashboard/dashboard.jsp(60,8) name = value type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_form_005fcheckbox_005f0.setValue((java.lang.Object) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${al.assignmentId}", java.lang.Object.class, (PageContext)_jspx_page_context, null, false));
    int[] _jspx_push_body_count_form_005fcheckbox_005f0 = new int[] { 0 };
    try {
      int _jspx_eval_form_005fcheckbox_005f0 = _jspx_th_form_005fcheckbox_005f0.doStartTag();
      if (_jspx_th_form_005fcheckbox_005f0.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } catch (Throwable _jspx_exception) {
      while (_jspx_push_body_count_form_005fcheckbox_005f0[0]-- > 0)
        out = _jspx_page_context.popBody();
      _jspx_th_form_005fcheckbox_005f0.doCatch(_jspx_exception);
    } finally {
      _jspx_th_form_005fcheckbox_005f0.doFinally();
      _005fjspx_005ftagPool_005fform_005fcheckbox_0026_005fvalue_005fpath_005fnobody.reuse(_jspx_th_form_005fcheckbox_005f0);
    }
    return false;
  }

  private boolean _jspx_meth_c_005fout_005f0(javax.servlet.jsp.tagext.JspTag _jspx_th_c_005fforEach_005f0, PageContext _jspx_page_context, int[] _jspx_push_body_count_c_005fforEach_005f0)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  c:out
    org.apache.taglibs.standard.tag.rt.core.OutTag _jspx_th_c_005fout_005f0 = (org.apache.taglibs.standard.tag.rt.core.OutTag) _005fjspx_005ftagPool_005fc_005fout_0026_005fvalue_005fnobody.get(org.apache.taglibs.standard.tag.rt.core.OutTag.class);
    _jspx_th_c_005fout_005f0.setPageContext(_jspx_page_context);
    _jspx_th_c_005fout_005f0.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_c_005fforEach_005f0);
    // /WEB-INF/jsp/dashboard/dashboard.jsp(61,8) name = value type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005fout_005f0.setValue((java.lang.Object) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${al.lesonName}", java.lang.Object.class, (PageContext)_jspx_page_context, null, false));
    int _jspx_eval_c_005fout_005f0 = _jspx_th_c_005fout_005f0.doStartTag();
    if (_jspx_th_c_005fout_005f0.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fc_005fout_0026_005fvalue_005fnobody.reuse(_jspx_th_c_005fout_005f0);
      return true;
    }
    _005fjspx_005ftagPool_005fc_005fout_0026_005fvalue_005fnobody.reuse(_jspx_th_c_005fout_005f0);
    return false;
  }

  private boolean _jspx_meth_fmt_005fformatDate_005f0(javax.servlet.jsp.tagext.JspTag _jspx_th_c_005fforEach_005f0, PageContext _jspx_page_context, int[] _jspx_push_body_count_c_005fforEach_005f0)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  fmt:formatDate
    org.apache.taglibs.standard.tag.rt.fmt.FormatDateTag _jspx_th_fmt_005fformatDate_005f0 = (org.apache.taglibs.standard.tag.rt.fmt.FormatDateTag) _005fjspx_005ftagPool_005ffmt_005fformatDate_0026_005fvalue_005ftype_005fpattern_005fnobody.get(org.apache.taglibs.standard.tag.rt.fmt.FormatDateTag.class);
    _jspx_th_fmt_005fformatDate_005f0.setPageContext(_jspx_page_context);
    _jspx_th_fmt_005fformatDate_005f0.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_c_005fforEach_005f0);
    // /WEB-INF/jsp/dashboard/dashboard.jsp(61,42) name = value type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_fmt_005fformatDate_005f0.setValue((java.util.Date) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${al.assignmentStart}", java.util.Date.class, (PageContext)_jspx_page_context, null, false));
    // /WEB-INF/jsp/dashboard/dashboard.jsp(61,42) name = type type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_fmt_005fformatDate_005f0.setType("both");
    // /WEB-INF/jsp/dashboard/dashboard.jsp(61,42) name = pattern type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_fmt_005fformatDate_005f0.setPattern("MM/dd/yyyy");
    int _jspx_eval_fmt_005fformatDate_005f0 = _jspx_th_fmt_005fformatDate_005f0.doStartTag();
    if (_jspx_th_fmt_005fformatDate_005f0.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005ffmt_005fformatDate_0026_005fvalue_005ftype_005fpattern_005fnobody.reuse(_jspx_th_fmt_005fformatDate_005f0);
      return true;
    }
    _005fjspx_005ftagPool_005ffmt_005fformatDate_0026_005fvalue_005ftype_005fpattern_005fnobody.reuse(_jspx_th_fmt_005fformatDate_005f0);
    return false;
  }

  private boolean _jspx_meth_form_005fcheckbox_005f1(javax.servlet.jsp.tagext.JspTag _jspx_th_form_005fform_005f0, PageContext _jspx_page_context, int[] _jspx_push_body_count_form_005fform_005f0)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  form:checkbox
    org.springframework.web.servlet.tags.form.CheckboxTag _jspx_th_form_005fcheckbox_005f1 = (org.springframework.web.servlet.tags.form.CheckboxTag) _005fjspx_005ftagPool_005fform_005fcheckbox_0026_005fpath_005fonclick_005fnobody.get(org.springframework.web.servlet.tags.form.CheckboxTag.class);
    _jspx_th_form_005fcheckbox_005f1.setPageContext(_jspx_page_context);
    _jspx_th_form_005fcheckbox_005f1.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_form_005fform_005f0);
    // /WEB-INF/jsp/dashboard/dashboard.jsp(82,7) name = path type = null reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_form_005fcheckbox_005f1.setPath("cellColor");
    // /WEB-INF/jsp/dashboard/dashboard.jsp(82,7) name = onclick type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_form_005fcheckbox_005f1.setOnclick("javascript:reloadDashboard()");
    int[] _jspx_push_body_count_form_005fcheckbox_005f1 = new int[] { 0 };
    try {
      int _jspx_eval_form_005fcheckbox_005f1 = _jspx_th_form_005fcheckbox_005f1.doStartTag();
      if (_jspx_th_form_005fcheckbox_005f1.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } catch (Throwable _jspx_exception) {
      while (_jspx_push_body_count_form_005fcheckbox_005f1[0]-- > 0)
        out = _jspx_page_context.popBody();
      _jspx_th_form_005fcheckbox_005f1.doCatch(_jspx_exception);
    } finally {
      _jspx_th_form_005fcheckbox_005f1.doFinally();
      _005fjspx_005ftagPool_005fform_005fcheckbox_0026_005fpath_005fonclick_005fnobody.reuse(_jspx_th_form_005fcheckbox_005f1);
    }
    return false;
  }

  private boolean _jspx_meth_c_005furl_005f12(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  c:url
    org.apache.taglibs.standard.tag.rt.core.UrlTag _jspx_th_c_005furl_005f12 = (org.apache.taglibs.standard.tag.rt.core.UrlTag) _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.get(org.apache.taglibs.standard.tag.rt.core.UrlTag.class);
    _jspx_th_c_005furl_005f12.setPageContext(_jspx_page_context);
    _jspx_th_c_005furl_005f12.setParent(null);
    // /WEB-INF/jsp/dashboard/dashboard.jsp(97,0) name = var type = java.lang.String reqTime = false required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f12.setVar("ajaxLoadDashboardUrl");
    // /WEB-INF/jsp/dashboard/dashboard.jsp(97,0) name = value type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f12.setValue("/api/dashboard/");
    int _jspx_eval_c_005furl_005f12 = _jspx_th_c_005furl_005f12.doStartTag();
    if (_jspx_th_c_005furl_005f12.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f12);
      return true;
    }
    _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f12);
    return false;
  }

  private boolean _jspx_meth_c_005furl_005f13(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  c:url
    org.apache.taglibs.standard.tag.rt.core.UrlTag _jspx_th_c_005furl_005f13 = (org.apache.taglibs.standard.tag.rt.core.UrlTag) _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.get(org.apache.taglibs.standard.tag.rt.core.UrlTag.class);
    _jspx_th_c_005furl_005f13.setPageContext(_jspx_page_context);
    _jspx_th_c_005furl_005f13.setParent(null);
    // /WEB-INF/jsp/dashboard/dashboard.jsp(98,0) name = var type = java.lang.String reqTime = false required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f13.setVar("ajaxResetGroupsUrl");
    // /WEB-INF/jsp/dashboard/dashboard.jsp(98,0) name = value type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
    _jspx_th_c_005furl_005f13.setValue("/api/dashboard/resetGroup");
    int _jspx_eval_c_005furl_005f13 = _jspx_th_c_005furl_005f13.doStartTag();
    if (_jspx_th_c_005furl_005f13.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f13);
      return true;
    }
    _005fjspx_005ftagPool_005fc_005furl_0026_005fvar_005fvalue_005fnobody.reuse(_jspx_th_c_005furl_005f13);
    return false;
  }
}
