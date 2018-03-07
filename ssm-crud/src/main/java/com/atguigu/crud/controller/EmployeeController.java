package com.atguigu.crud.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
/*
 * 处理员工CRUD
 */
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.Msg;
import com.atguigu.crud.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
@Controller
public class EmployeeController {
	
	@Autowired
	EmployeeService employeeService;
	/*
	 * 单个批量删除二合一方法
	 * 批量删除：1-2-3
	 * 单个删除：1
	 */
	@RequestMapping(value="/emp/{ids}",method=RequestMethod.DELETE)
	@ResponseBody
	public Msg deleteEmp(@PathVariable("ids")String ids){
		//批量删除
		if(ids.contains("-")){
			List<Integer> del_ids = new ArrayList<Integer>();
			String[] str_ids = ids.split("-");
			//组装id的集合
			for(String string:str_ids){
				del_ids.add(Integer.parseInt(string));
			}
			employeeService.deleteBatch(del_ids);
		}else{  //单个删除
			Integer id = Integer.parseInt(ids);
			employeeService.deleteEmp(id);
		}
		return Msg.success();
	}
	
	/*
	 * 如果直接发送ajax的PUT请求
	 * 封装的数据employee
	 * Employee [empId=10, empName=null, gender=null, email=null, dId=null, department=null]
	 * 问题：
	 * 请求体中有数据，但是Employee对象封装不上
	 * update tbl_emp where emp_id = 10
	 * 原因：tomcat:
	 * 1.将请求体中的数据，封装成一个map,
	 * 2.request.getParameter("empName")就会从这个map中取值
	 * 3.SpringMVC封装POJO对象的时候，会从上面那种方式去取值，所以拿不到
	 * AJAX发送ＰＵＴ请求引发的血案
	 * 　　　　　ＰＵＴ请求,请求体中的数据，request.getParameter("empName")拿不到
	 *         tomcat一看是put请求，就不会封装请求体中的数据为map，只有post请求服务器才会封装请求体为map
	 * 解决方案：
	 * 1.我们要能要能直接发送PUT请求还要封装请求体中的数据
	 * 2.配置上HttpPutFormContentFilter
	 * 3.他的作用是将请求体中的数据解析包装成一个map
	 * 4.request被重新包装，request.getParameter()被重写，就会从自己封装的map中取数据
	 * 
	 */
	@RequestMapping(value="/emp/{empId}",method=RequestMethod.PUT)
	@ResponseBody
	public Msg saveEmp(Employee employee,HttpServletRequest request){
		//System.out.println("请求体中的值："+request.getParameter("gender"));//测试确实拿不到啊
		//System.out.println("将要更新的员工数据"+employee.toString());
		employeeService.updateEmp(employee);
		return Msg.success();
	}
	
	
	//根据id查询员工
	@RequestMapping(value="/emp/{id}",method=RequestMethod.GET)
	@ResponseBody    //注解从路劲中取出id
	public Msg getEmp(@PathVariable("id")Integer id) {
		Employee employee = employeeService.getEmp(id);
		return Msg.success().add("emp", employee);
	}
	
	
	
	//保存员工，支持JSR303校验，需要导入Hibernate-Validator包
	@RequestMapping(value="/emp",method = RequestMethod.POST)
	@ResponseBody                               //BindingResult是用来封装校验的结果的
	public Msg saveEmp(@Valid Employee employee,BindingResult result){
		if(result.hasErrors()){
			//校验失败,应该返回失败，在模态框中显示校验失败的错误信息
			Map<String, Object> map = new HashMap<String, Object>();
			List<FieldError> errors = result.getFieldErrors();
			for(FieldError fieldError:errors){
				System.out.println("错误的字段名："+fieldError.getField());
				System.out.println("错误信息："+fieldError.getDefaultMessage());
				map.put(fieldError.getField(), fieldError.getDefaultMessage());
			}
			return Msg.fail().add("errorFields", map);
		}else{
			employeeService.saveEmp(employee);
			return Msg.success();
		}
	}
	
	//检查用户名是否可用
	@RequestMapping("/checkuser")
	@ResponseBody
	public Msg checkuser(@RequestParam("empName")String empName){
		//先判断用户名是否合法
		String regex = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})";
		if(!empName.matches(regex)){
			return Msg.fail().add("va_msg", "用户名必须是6-16位字母或者数字的组合或者2-5个汉字");
		}
		//然后进行数据库用户名是否重复校验
		boolean b = employeeService.checkUser(empName);
		if(b){
			return Msg.success();
		}else{
			return Msg.fail().add("va_msg", "用户名已存在，不可用");
		}
	}
	
	
	
	/*
	 * @ResponseBody要能正常工作，需要导入jackson包
	 */
	@RequestMapping("/emps")
	@ResponseBody
	public Msg getEmpsWithJson(@RequestParam(value = "pn",defaultValue = "1")Integer pn){
		// 这不是一个分页查询
		// 引入PageHelper分页插件
		// 在查询之前只需要调用，传入页码，以及分页的大小
		PageHelper.startPage(pn, 5);
		// startPage后面紧跟的查询就是一个分页查询
		List<Employee> emps = employeeService.getAll();
		// 使用PageInfo包装我们查询后的结果，只需要将PageInfo交给页面就行了
		// PageInfo里面封装了详细的分页信息，包括有我们查询出来的数据
		PageInfo page = new PageInfo(emps, 5); // 第二个参数5是传入连续显示的页数
		return Msg.success().add("PageInfo", page);
	}
	
	
	

	//查询员工数据，做的是分页查询
	//@RequestMapping("/emps")                             
	public String getEmps(@RequestParam(value = "pn",defaultValue = "1")Integer pn,Model model){
		//这不是一个分页查询
		//引入PageHelper分页插件
		//在查询之前只需要调用，传入页码，以及分页的大小
		PageHelper.startPage(pn, 5);
		//startPage后面紧跟的查询就是一个分页查询
		List<Employee> emps = employeeService.getAll();
		//使用PageInfo包装我们查询后的结果，只需要将PageInfo交给页面就行了
		//PageInfo里面封装了详细的分页信息，包括有我们查询出来的数据
		PageInfo page = new PageInfo(emps,5);  //第二个参数5是传入连续显示的页数
		//model会将返回信息带给页面
		model.addAttribute("pageInfo", page);
		return "list";
	}
}
