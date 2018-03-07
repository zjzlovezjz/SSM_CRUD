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
 * ����Ա��CRUD
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
	 * ��������ɾ������һ����
	 * ����ɾ����1-2-3
	 * ����ɾ����1
	 */
	@RequestMapping(value="/emp/{ids}",method=RequestMethod.DELETE)
	@ResponseBody
	public Msg deleteEmp(@PathVariable("ids")String ids){
		//����ɾ��
		if(ids.contains("-")){
			List<Integer> del_ids = new ArrayList<Integer>();
			String[] str_ids = ids.split("-");
			//��װid�ļ���
			for(String string:str_ids){
				del_ids.add(Integer.parseInt(string));
			}
			employeeService.deleteBatch(del_ids);
		}else{  //����ɾ��
			Integer id = Integer.parseInt(ids);
			employeeService.deleteEmp(id);
		}
		return Msg.success();
	}
	
	/*
	 * ���ֱ�ӷ���ajax��PUT����
	 * ��װ������employee
	 * Employee [empId=10, empName=null, gender=null, email=null, dId=null, department=null]
	 * ���⣺
	 * �������������ݣ�����Employee�����װ����
	 * update tbl_emp where emp_id = 10
	 * ԭ��tomcat:
	 * 1.���������е����ݣ���װ��һ��map,
	 * 2.request.getParameter("empName")�ͻ�����map��ȡֵ
	 * 3.SpringMVC��װPOJO�����ʱ�򣬻���������ַ�ʽȥȡֵ�������ò���
	 * AJAX���ͣУգ�����������Ѫ��
	 * �����������Уգ�����,�������е����ݣ�request.getParameter("empName")�ò���
	 *         tomcatһ����put���󣬾Ͳ����װ�������е�����Ϊmap��ֻ��post����������Ż��װ������Ϊmap
	 * ���������
	 * 1.����Ҫ��Ҫ��ֱ�ӷ���PUT����Ҫ��װ�������е�����
	 * 2.������HttpPutFormContentFilter
	 * 3.���������ǽ��������е����ݽ�����װ��һ��map
	 * 4.request�����°�װ��request.getParameter()����д���ͻ���Լ���װ��map��ȡ����
	 * 
	 */
	@RequestMapping(value="/emp/{empId}",method=RequestMethod.PUT)
	@ResponseBody
	public Msg saveEmp(Employee employee,HttpServletRequest request){
		//System.out.println("�������е�ֵ��"+request.getParameter("gender"));//����ȷʵ�ò�����
		//System.out.println("��Ҫ���µ�Ա������"+employee.toString());
		employeeService.updateEmp(employee);
		return Msg.success();
	}
	
	
	//����id��ѯԱ��
	@RequestMapping(value="/emp/{id}",method=RequestMethod.GET)
	@ResponseBody    //ע���·����ȡ��id
	public Msg getEmp(@PathVariable("id")Integer id) {
		Employee employee = employeeService.getEmp(id);
		return Msg.success().add("emp", employee);
	}
	
	
	
	//����Ա����֧��JSR303У�飬��Ҫ����Hibernate-Validator��
	@RequestMapping(value="/emp",method = RequestMethod.POST)
	@ResponseBody                               //BindingResult��������װУ��Ľ����
	public Msg saveEmp(@Valid Employee employee,BindingResult result){
		if(result.hasErrors()){
			//У��ʧ��,Ӧ�÷���ʧ�ܣ���ģ̬������ʾУ��ʧ�ܵĴ�����Ϣ
			Map<String, Object> map = new HashMap<String, Object>();
			List<FieldError> errors = result.getFieldErrors();
			for(FieldError fieldError:errors){
				System.out.println("������ֶ�����"+fieldError.getField());
				System.out.println("������Ϣ��"+fieldError.getDefaultMessage());
				map.put(fieldError.getField(), fieldError.getDefaultMessage());
			}
			return Msg.fail().add("errorFields", map);
		}else{
			employeeService.saveEmp(employee);
			return Msg.success();
		}
	}
	
	//����û����Ƿ����
	@RequestMapping("/checkuser")
	@ResponseBody
	public Msg checkuser(@RequestParam("empName")String empName){
		//���ж��û����Ƿ�Ϸ�
		String regex = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})";
		if(!empName.matches(regex)){
			return Msg.fail().add("va_msg", "�û���������6-16λ��ĸ�������ֵ���ϻ���2-5������");
		}
		//Ȼ��������ݿ��û����Ƿ��ظ�У��
		boolean b = employeeService.checkUser(empName);
		if(b){
			return Msg.success();
		}else{
			return Msg.fail().add("va_msg", "�û����Ѵ��ڣ�������");
		}
	}
	
	
	
	/*
	 * @ResponseBodyҪ��������������Ҫ����jackson��
	 */
	@RequestMapping("/emps")
	@ResponseBody
	public Msg getEmpsWithJson(@RequestParam(value = "pn",defaultValue = "1")Integer pn){
		// �ⲻ��һ����ҳ��ѯ
		// ����PageHelper��ҳ���
		// �ڲ�ѯ֮ǰֻ��Ҫ���ã�����ҳ�룬�Լ���ҳ�Ĵ�С
		PageHelper.startPage(pn, 5);
		// startPage��������Ĳ�ѯ����һ����ҳ��ѯ
		List<Employee> emps = employeeService.getAll();
		// ʹ��PageInfo��װ���ǲ�ѯ��Ľ����ֻ��Ҫ��PageInfo����ҳ�������
		// PageInfo�����װ����ϸ�ķ�ҳ��Ϣ�����������ǲ�ѯ����������
		PageInfo page = new PageInfo(emps, 5); // �ڶ�������5�Ǵ���������ʾ��ҳ��
		return Msg.success().add("PageInfo", page);
	}
	
	
	

	//��ѯԱ�����ݣ������Ƿ�ҳ��ѯ
	//@RequestMapping("/emps")                             
	public String getEmps(@RequestParam(value = "pn",defaultValue = "1")Integer pn,Model model){
		//�ⲻ��һ����ҳ��ѯ
		//����PageHelper��ҳ���
		//�ڲ�ѯ֮ǰֻ��Ҫ���ã�����ҳ�룬�Լ���ҳ�Ĵ�С
		PageHelper.startPage(pn, 5);
		//startPage��������Ĳ�ѯ����һ����ҳ��ѯ
		List<Employee> emps = employeeService.getAll();
		//ʹ��PageInfo��װ���ǲ�ѯ��Ľ����ֻ��Ҫ��PageInfo����ҳ�������
		//PageInfo�����װ����ϸ�ķ�ҳ��Ϣ�����������ǲ�ѯ����������
		PageInfo page = new PageInfo(emps,5);  //�ڶ�������5�Ǵ���������ʾ��ҳ��
		//model�Ὣ������Ϣ����ҳ��
		model.addAttribute("pageInfo", page);
		return "list";
	}
}
