<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>员工列表</title>
<%
   pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<!-- web路径，不以/开始的路径，找资源，以当前资源的路径为基准，经常容易出问题
     以/开始的相对路径，找资源，以服务器的路径为标准(http://localhost:3306)
 -->
<script type="text/javascript" src="${APP_PATH}/static/js/jquery-1.12.4.min.js"></script>
<link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
 <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>
    <!-- 员工修改的模态框 -->
	<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">修改员工</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal">
					    <!-- 员工姓名 -->
						<div class="form-group">
							<label for="empName_add_input" class="col-sm-2 control-label">empName</label>
							<div class="col-sm-10">
								<p class="form-control-static" id="empName_update_static"></p>
							</div>
						</div>
						<!-- 员工邮箱 -->
						<div class="form-group">
							<label for="email_add_input" class="col-sm-2 control-label">email</label>
							<div class="col-sm-10">
								<input type="text" name="email" class="form-control" id="email_update_input"
									placeholder="email@qq.com">
								<span class="help-block"></span>
							</div>
						</div>
						<!-- 员工性别 -->
						<div class="form-group">
							<label  class="col-sm-2 control-label">gender</label>
							<div class="col-sm-10">
								<label class="radio-inline"> <input type="radio"
									name="gender" id="gender1_update_input" value="M" checked="checked">
									男
								</label> <label class="radio-inline"> <input type="radio"
									name="gender" id="gender2_update_input" value="F">
									女
								</label>
							</div>
						</div>
						<!-- 部门名称 -->
						<div class="form-group">
							<label  class="col-sm-2 control-label">department</label>
							<div class="col-sm-4">
							    <!-- 部门下拉列表，值设置为部门id即可 -->
								<select class="form-control" name="dId"> 
								</select>
							</div>
						</div>
						
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 员工添加的模态框 -->
	<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">添加员工</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal">
					    <!-- 员工姓名 -->
						<div class="form-group">
							<label for="empName_add_input" class="col-sm-2 control-label">empName</label>
							<div class="col-sm-10">
								<input type="text" name="empName" class="form-control" id="empName_add_input"
									placeholder="empName">
								<span class="help-block"></span>
							</div>
						</div>
						<!-- 员工邮箱 -->
						<div class="form-group">
							<label for="email_add_input" class="col-sm-2 control-label">email</label>
							<div class="col-sm-10">
								<input type="text" name="email" class="form-control" id="email_add_input"
									placeholder="email@qq.com">
								<span class="help-block"></span>
							</div>
						</div>
						<!-- 员工性别 -->
						<div class="form-group">
							<label  class="col-sm-2 control-label">gender</label>
							<div class="col-sm-10">
								<label class="radio-inline"> <input type="radio"
									name="gender" id="gender1_add_input" value="M" checked="checked">
									男
								</label> <label class="radio-inline"> <input type="radio"
									name="gender" id="gender2_add_input" value="F">
									女
								</label>
							</div>
						</div>
						<!-- 部门名称 -->
						<div class="form-group">
							<label  class="col-sm-2 control-label">department</label>
							<div class="col-sm-4">
							    <!-- 部门下拉列表，值设置为部门id即可 -->
								<select class="form-control" name="dId"> 
								</select>
							</div>
						</div>
						
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
				</div>
			</div>
		</div>
	</div>


	<!-- 搭建显示页面 -->
   <div class="container">
          <!-- 标题行 -->
          <div class="row">
                <div class="col-md-12">
                    <h1>SSM-CRUD</h1>
                </div>
          </div>
          <!-- 按钮行，新增，删除 -->
          <div class="row">
                <div class="col-md-4 col-md-offset-8">
                      <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
                      <button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
                </div>
          </div>
          <!-- 表格行，显示数据 -->
		<div class="row">
			<div class="col-md-12">
				<table class="table table-bordered table-hover" id="emps_table">
					<thead>
						<tr>
						    <th>
						       <input type="checkbox" id="check_all"/>
						    </th>
							<th>#</th>
							<th>empName</th>
							<th>gender</th>
							<th>email</th>
							<th>deptName</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					    
					</tbody>
				</table>
			</div>
		</div>
		<!-- 显示分页信息行 -->
          <div class="row">
               <!-- 分页文字信息 -->
               <div class="col-md-6" id="page_info_area">
                                         
               </div>
               <!-- 分业条信息 -->
               <div class="col-md-6" id="page_nav_area">
				     <nav aria-label="Page navigation" id="nav">
				     
				     </nav>
			   </div>
          </div>
   </div>  
   <script type="text/javascript">
         var totalRecords;
         //1.页面加载完成后，直接发送一个ajax请求，拿到分页的数据
         $(function(){
        	 //去首页
        	 to_page(1);
		 });
         
         function to_page(pn){
        	 $.ajax({
				  url: "${APP_PATH}/emps",
				  data: "pn="+pn,
				  type: "GET",
				  success: function(result){        //请求成功的回调函数
					   //console.log(result);
				       //1.解析并显示员工数据
				       build_emps_table(result);
				       //2.解析并显示分页的信息
				       build_page_info(result);
				       //解析显示分页条数据
				       build_page_nav(result);   
				  }
			  });
		 }
         
         function build_emps_table(result){
        	  //避免翻去下一页的时候会自动勾选全选框
        	  $("#check_all").prop("checked",1==2);
        	  //清空表格
        	  $("#emps_table tbody").empty();
			  var emps = result.extend.PageInfo.list;
			  $.each(emps,function(index,item){
				   //alert(item.empName+index);
				   var checkBoxTd = $("<td><input type='checkbox' class='check_item' /></td>");
				   var empIdTd = $("<td></td>").append(item.empId);
				   var empNameTd = $("<td></td>").append(item.empName);
				   var genderTd = $("<td></td>").append(item.gender=='M'?"男":"女");
				   var emailTd = $("<td></td>").append(item.email);
				   var deptNameTd = $("<td></td>").append(item.department.deptName);
			       /*
			         <button class="btn btn-primary btn-sm">
                                   <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                                                                           编辑
                               </button>
                                       由于append的返回值还是原来的，所以可以一直append下去，注意学会看jq的文档                                                    
			       */
				   var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
				                 .append($("<span></span>").addClass("glyphicon glyphicon-pencil"))
				                 .append("编辑");
                                       
                   //为编辑按钮添加一个自定义的属性，来表示当前员工id
                   editBtn.attr("edit-id",item.empId);
                   
				   var delBtn =  $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
	                             .append($("<span></span>").addClass("glyphicon glyphicon-trash"))
	                             .append("删除");
				  //为删除按钮添加一个自定义的属性，来表示当前员工id
				   delBtn.attr("del-id",item.empId);
				   var btnTd = $("<td></td>").append(editBtn).append("  ").append(delBtn);
				   //append方法执行完之后还是返回原来的元素，所以可以一直加
				   $("<tr></tr>").append(checkBoxTd)
				                 .append(empIdTd).append(empNameTd)
				                 .append(genderTd).append(emailTd).append(deptNameTd)
				                 .append(btnTd)
				                 .appendTo("#emps_table tbody"); 
			  });
		 }
         
         //解析显示分页信息
         function build_page_info(result){
        	       //清空分页信息
        	       $("#page_info_area").empty();
			       $("#page_info_area").append("当前第"+result.extend.PageInfo.pageNum+
			    		   "页，总共"+result.extend.PageInfo.pages+"页，总共"+result.extend.PageInfo.total+"条记录")
			       totalRecords = result.extend.PageInfo.total;
		 }
         
         //解析显示分页导航条,加上链接
         function build_page_nav(result){
        	       //清空导航条
        	       $("#nav").empty();
			       //page_nav_area
			       var ul = $("<ul></ul>").addClass("pagination");
			       
			       //构建元素
			       var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
			       var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
			       if(result.extend.PageInfo.hasPreviousPage == false){
			    	   firstPageLi.addClass("disabled");
			    	   prePageLi.addClass("disabled");
			       }else{
			    	 //为元素绑定翻页事件
				       firstPageLi.click(function(){
				    	   to_page(1);
					   });
				       prePageLi.click(function(){
				    	   to_page(result.extend.PageInfo.pageNum - 1);
					   });
			       }
			       
			       var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
			       var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
			       
			       if(result.extend.PageInfo.hasNextPage == false){
			    	   nextPageLi.addClass("disabled");
			    	   lastPageLi.addClass("disabled");
			       }else{
			    	   nextPageLi.click(function(){
				    	   to_page(result.extend.PageInfo.pageNum + 1);
					   });
				       lastPageLi.click(function(){
				    	   to_page(result.extend.PageInfo.pages);
					   });
			       }  
			       //给ul添加首页和前一页的提示
			       ul.append(firstPageLi).append(prePageLi);
			       //遍历每一个的回调函数,可以传两个参数，一个是索引，一个是当前元素
			       $.each(result.extend.PageInfo.navigatepageNums,function(index,item){
			    	    
			    	    var numLi = $("<li></li>").append($("<a></a>").append(item)).attr("value",item);
			    	    if(result.extend.PageInfo.pageNum == item){
			    	    	numLi.addClass("active");
			    	    }
			    	    numLi.click(function(){
			    	    	to_page(item);
						});
			    	    //遍历给ul添加页码提示
			    	    ul.append(numLi);
			       });
			       //添加下一页和末页的提示
			       ul.append(nextPageLi).append(lastPageLi);
			       //添加到<nav>中
			       $("#nav").append(ul);
		 }
         //清空表单样式和内容
         function reset_form(ele){
			 $(ele)[0].reset();
			 //清空表单样式
			 $(ele).find("*").removeClass("has-error has-success");
			 $(ele).find(".help-block").text("");
		 }
         
         //点击新增按钮弹出模态框
         $("#emp_add_modal_btn").click(function(){
        	 //每次弹出之前清除表单数据（表单完整重置）包括表单的数据和表单的样式
        	 reset_form("#empAddModal form")
        	 //$("#empAddModal form")[0].reset();
        	 //发送ajax请求，获取部门信息，显示在下拉列表中
        	 getDepts("#empAddModal select");
        	 //弹出模态框
        	 $('#empAddModal').modal({
        		 backdrop:"static"
        	 });
		 });
         
         //查出所有部门信息并显示在下拉列表中
         function getDepts(ele){
			 $.ajax({
				 url: "${APP_PATH}/depts",
				 type: "GET",
				 success: function(result){
					 //console.log(result);
					 //extend:{depts: [{deptId: 1, deptName: "开发部"}, {deptId: 2, deptName: "测试部"}, {deptId: 3, deptName: "销售部"}]}
					 //显示部门信息在下拉列表中
					 $(ele).empty(); //每次遍历前记得清空数据
					 $.each(result.extend.depts,function(){
						  var optionEle = $("<option></option>").append(this.deptName).attr("value",this.deptId); 
						  optionEle.appendTo(ele);
					 });
				 }
			 });
		 }
               
         //校验表单数据
         function validate_add_form(){
			 //1.拿到校验的数据，使用正则表达式校验
			 var empName = $("#empName_add_input").val();
			 var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/ ;
			 if(!regName.test(empName)){
				 //alert("用户名可以是2-5位中文或者6-16位英文数字");
				 //每次来时都应该清空这个元素之前的样式
				 show_validate_msg("#empName_add_input","error","用户名可以是2-5位中文或者6-16位英文数字");
				 return false;
			 }else{
				 show_validate_msg("#empName_add_input","success","");
			 };
			 //2.校验邮箱信息
			 var email = $("#email_add_input").val();
			 var regEmail = /(^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$)/;
			 if(!regEmail.test(email)){
				 //alert("邮箱格式不正确");
				 show_validate_msg("#email_add_input","error","邮箱格式不正确");
				 return false;
			 }else{
				 show_validate_msg("#email_add_input","success","");
				// $("#email_add_input").parent().addClass("has-success");
				// $("#email_add_input").next("span").text("");
			 };
			 return true;
		 }
         
         function show_validate_msg(ele,status,msg){
        	 //清除当前元素的校验状态
        	 $(ele).parent().removeClass("has-success has-error");
        	 $(ele).next("span").text("");
        	 if("success" == status){
        		 $(ele).parent().addClass("has-success");
				 $(ele).next("span").text(msg);
        	 }else if("error" == status){
        		 $(ele).parent().addClass("has-error");
				 $(ele).next("span").text(msg);
        	 }
         }
         
         //校验用户名是否可用
         $("#empName_add_input").change(function() {
        	 var empName = this.value;
			 //发送ajax请求校验用户名是否可用
			 $.ajax({
				 url: "${APP_PATH}/checkuser",
				 data: "empName="+empName,
				 type: "POST",
				 success: function(result){
					 if(result.code == 100){
						 show_validate_msg("#empName_add_input","success","用户名可用");
						 $("#emp_save_btn").attr("ajax-va","success");
					 }else{
						 
						 show_validate_msg("#empName_add_input","error",result.extend.va_msg);
						 $("#emp_save_btn").attr("ajax-va","error");
					 }
				 }
			 });
			 
		 });
         
         
         $("#emp_save_btn").click(function(){
			 //1.模态框中填写的表单数据进行保存,首先进行数据校验
			 if(!validate_add_form()){
				 return false;
			 }  
			 //看看名字是否合格再发请求
			 if($(this).attr("ajax-va")=="error"){
				 return false;
			 } 
			 //2.发送ajax请求保存员工
			 //alert($("#empAddModal form").serialize());
			 $.ajax({
				 url: "${APP_PATH}/emp",
				 type: "POST",
				 data: $("#empAddModal form").serialize(),//要发送的数据
				 success: function(result){
					  // alert(result.msg);
					  if (result.code==100) {
						  //员工保存成功
						  //1.关闭模态框,方法参照bootStrap里面提供了完整的使用方法
						  $("#empAddModal").modal('hide');
						  //2.来到最后一页显示保存的数据
						  //发送ajax请求，显示最后一页数据,利用分页插件中的很大的页码默认调转到最后一页，简直开挂
						  to_page(totalRecords);
					  }else{
                          //显示失败信息
                          //console.log(result);
                          //有哪个字段的错误信息就显示哪个字段的
                          //alert(result.extend.errorFields.email);
                          //alert(result.extend.errorFields.empName);
                          if(undefined != result.extend.errorFields.email){
                        	  //显示邮箱的错误信息
                        	  show_validate_msg("#email_add_input","error",result.extend.errorFields.email);
                          }
                          if(undefined != result.extend.errorFields.empName){
                        	  //显示员工名字的错误信息
                        	  show_validate_msg("#empName_add_input","error",result.extend.errorFields.empName);
                          }   
					  }  
				 }
			 }); 
		 });
             
         //因为我们是在按钮创建之前就绑定了事件，所以按钮绑定不上
         //1.可以在创建按钮的时候绑定事件2.绑定点击.live()但是jq新版本没有Live方法，使用on进行替代
         $(document).on("click",".edit_btn",function(){
			  //alert("edit");
			  //1.查出部门信息，并显示部门列表
			  getDepts("#empUpdateModal select");
			 //0.查出员工信息，显示员工信息
			  getEmp($(this).attr("edit-id"));
			 //把员工id传递给模态框的更新按钮
			  $("#emp_update_btn").attr("edit-id",$(this).attr("edit-id"));
			  //2.弹出模态框
        	  $('#empUpdateModal').modal({
        		 backdrop:"static"
        	  });
		 });
         
         function getEmp(id){
			  $.ajax({
				 url: "${APP_PATH}/emp/"+id,
				 type: "GET",
				 success: function(result){
					  //console.log(result);
					  var empData = result.extend.emp;
					  $("#empName_update_static").text(empData.empName);
					  $("#email_update_input").val(empData.email);
					  $("#empUpdateModal input[name=gender]").val([empData.gender]);
					  $("#empUpdateModal select").val([empData.dId]);
				 }
			  });
		 }
         
         //点击更新，更新员工信息
         $("#emp_update_btn").click(function(){
        	  //1.验证邮箱是否合法
        	 var email = $("#email_update_input").val();
			 var regEmail = /(^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$)/;
			 if(!regEmail.test(email)){
				 show_validate_msg("#email_update_input","error","邮箱格式不正确");
				 return false;
			 }else{
				 show_validate_msg("#email_update_input","success","");
			 };
			 //2.发送ajax请求保存员工更新数据
			 $.ajax({
				 url: "${APP_PATH}/emp/"+$(this).attr("edit-id"),
				 type: "PUT",
				 data: $("#empUpdateModal form").serialize(),
			     success: function(result){
					//alert(result.msg); 
					//1.关闭模态框
					$("#empUpdateModal").modal("hide");
					//2.回到本页面
					//alert($("#nav .active").attr("value"));
					to_page($("#nav .active").attr("value"));
				 }
			 }); 
         });
         
             //单个删除
			 $(document).on("click", ".delete_btn", function(){
                    //1.弹出是否确认删除对话框
                    //alert($(this).parents("tr").find("td:eq(1)").text());
                    var empName = $(this).parents("tr").find("td:eq(2)").text();
                    var empId = $(this).attr("del-id");
                    if(confirm("确认删除【"+empName+"】吗？")){
                    	//确认发送ajax删除即可
                    	$.ajax({
                    		url: "${APP_PATH}/emp/"+empId,
                    		type: "DELETE",
                    		success: function(result){
                    			//alert(result.msg);
                    			//回到本页
                    			to_page($("#nav .active").attr("value"));
                    		}
                    	});
                    }
			 });
             
             //完成全选与全不选的功能
             $("#check_all").click(function(){
            	 //attr获取checked是undefined;
            	 //我们这些dom原生的属性，attr用来获取自定义属性的值
            	 //prop修改和获取dom原生属性的值
            	 $(".check_item").prop("checked",$(this).prop("checked"));
             });
             //当check_item分页内的所有内容全选的时候，check_all也要自动选上
             $(document).on("click",".check_item",function(){
            	 //判断当前选择的元素是否是五个
            	 var flag = $(".check_item:checked").length==$(".check_item").length;
            	 $("#check_all").prop("checked",flag);
             });
             
             //点击全部删除，就批量删除
             $("#emp_delete_all_btn").click(function(){
            	 var empNames = "";
            	 var del_idstr = "";
            	 $.each($(".check_item:checked"),function(){
            		//组装员工名字字符串
            		empNames += $(this).parents("tr").find("td:eq(2)").text()+",";
            		//组装员工id字符串
            		del_idstr += $(this).parents("tr").find("td:eq(1)").text()+"-";
            	 });
            	 //截取员工名字连接字符里面的多余的逗号
            	 empNames = empNames.substring(0, empNames.length-1);
            	 //去除删除员工多余的-
            	 del_idstr = del_idstr.substring(0, del_idstr.length-1);
            	 if(confirm("确认删除【"+empNames+"】吗？")){
            		//发送ajax请求删除
            		$.ajax({
            			url: "${APP_PATH}/emp/"+del_idstr,
            			type: "DELETE",
            			success: function(result){
            				alert(result.msg);
            				//回到当前页面
            				to_page($("#nav .active").attr("value"));
            			}
            		});
            	 }
             });
             
</script>
</body>
</html>