package com.atguigu.crud.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.EmployeeExample;
import com.atguigu.crud.bean.EmployeeExample.Criteria;
import com.atguigu.crud.dao.EmployeeMapper;

@Service
public class EmployeeService {
	
	@Autowired
	EmployeeMapper employeeMapper;

	//��ѯ����Ա��
	public List<Employee> getAll(){
		return employeeMapper.selectByExampleWithDept(null);
	}
    //Ա�����淽��
	public void saveEmp(Employee employee) {
		employeeMapper.insertSelective(employee);	
	}
	//�����û����Ƿ����,true������ã�FALSE��������
	public boolean checkUser(String empName) {
		EmployeeExample example = new EmployeeExample();
		//��������������Ҫ������
		Criteria criteria = example.createCriteria();
		criteria.andEmpNameEqualTo(empName);
		long count = employeeMapper.countByExample(example);
		return count==0;
	}
	//����id����Ա����Ϣ
	public Employee getEmp(Integer id){
		Employee employee = employeeMapper.selectByPrimaryKey(id);
		return employee;
	}
	//����Ա��
	public void updateEmp(Employee employee) {
		employeeMapper.updateByPrimaryKeySelective(employee);		
	}
	//ɾ����һԱ��
	public void deleteEmp(Integer id) {
		employeeMapper.deleteByPrimaryKey(id);
	}
	//����ɾ��Ա��
	public void deleteBatch(List<Integer> ids) {
		EmployeeExample example = new EmployeeExample();
		//��������������Ҫ������
		Criteria criteria = example.createCriteria();
		//delete from XXX where emp_id in(1,2,3)
		criteria.andEmpIdIn(ids);
		employeeMapper.deleteByExample(example);
	}
}
