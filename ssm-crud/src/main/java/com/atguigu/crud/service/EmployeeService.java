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

	//查询所有员工
	public List<Employee> getAll(){
		return employeeMapper.selectByExampleWithDept(null);
	}
    //员工保存方法
	public void saveEmp(Employee employee) {
		employeeMapper.insertSelective(employee);	
	}
	//检验用户名是否可用,true代表可用，FALSE代表不可用
	public boolean checkUser(String empName) {
		EmployeeExample example = new EmployeeExample();
		//创造条件，你需要的条件
		Criteria criteria = example.createCriteria();
		criteria.andEmpNameEqualTo(empName);
		long count = employeeMapper.countByExample(example);
		return count==0;
	}
	//根据id返回员工信息
	public Employee getEmp(Integer id){
		Employee employee = employeeMapper.selectByPrimaryKey(id);
		return employee;
	}
	//更新员工
	public void updateEmp(Employee employee) {
		employeeMapper.updateByPrimaryKeySelective(employee);		
	}
	//删除单一员工
	public void deleteEmp(Integer id) {
		employeeMapper.deleteByPrimaryKey(id);
	}
	//批量删除员工
	public void deleteBatch(List<Integer> ids) {
		EmployeeExample example = new EmployeeExample();
		//创造条件，你需要的条件
		Criteria criteria = example.createCriteria();
		//delete from XXX where emp_id in(1,2,3)
		criteria.andEmpIdIn(ids);
		employeeMapper.deleteByExample(example);
	}
}
