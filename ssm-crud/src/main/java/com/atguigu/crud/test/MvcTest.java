package com.atguigu.crud.test;

import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.atguigu.crud.bean.Employee;
import com.github.pagehelper.PageInfo;

/*
 * ʹ��Spring�ṩ�Ĳ���ģ����������ܣ�����CRUD�������ȷ��
 * Spring4���Ե�ʱ����Ҫservlet3.0��֧��
 */
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations={"classpath:applicationContext.xml","file:src/main/webapp/WEB-INF/dispatcherServlet-servlet.xml"})
public class MvcTest {
	//����SpringMVC��Ioc
	@Autowired
	WebApplicationContext context;
	
    //����MVC���󣬻�ȡ��������
	MockMvc mockMvc;
	
	@Before     //ÿ��ʹ�ö�Ҫ��ʼ�������@Before��Junit�ı�ǩ����ס��
	public void initMokMvc() {
		mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
	}
	
	@Test
	public void testPage() throws Exception{
		//ģ�������õ�����ֵ
		MvcResult result =
		mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pn", "1")).andReturn();
		//����ɹ����������л���PageInfo,���ǿ���ȥ��pageInfo������֤
		MockHttpServletRequest request = result.getRequest();
		PageInfo pi = (PageInfo) request.getAttribute("pageInfo");
		System.out.println("��ǰҳ�룺"+pi.getPageNum());
		System.out.println("��ҳ��"+pi.getPages());
		System.out.println("�ܼ�¼��"+pi.getTotal());
		System.out.println("��ҳ����Ҫ������ʾ��ҳ�룺");
		int[] nums = pi.getNavigatepageNums();
		for(int i:nums){
			System.out.print("  "+i);
		}
		//��ȡԱ������
		List<Employee> list = pi.getList();
		for (Employee employee : list) {
			System.out.println("ID:"+employee.getEmpId()+"==>Name:"+employee.getEmpName()+"==>dept:"+employee.getDepartment().getDeptName());
		}
	}
	
	
	
}
