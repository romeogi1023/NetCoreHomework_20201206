﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using NetCoreHomework_20201206.Models;
using NetCoreHomework_20201206.ViewModel;
using Omu.ValueInjecter;

namespace NetCoreHomework_20201206.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DepartmentsController : ControllerBase
    {
        private readonly ContosoUniversityContext _context;
        private readonly ContosoUniversityContextProcedures _spContext;

        public DepartmentsController(ContosoUniversityContext context, ContosoUniversityContextProcedures spContext)
        {
            _context = context;
            _spContext = spContext;
        }

        // GET: api/Departments
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Department>>> GetDepartment()
        {
            return await _context.Department.Where(x => x.IsDeleted != true).ToListAsync();
        }

        // GET: api/Departments/DepartmentCourseCount
        [HttpGet("DepartmentCourseCount")]
        public async Task<ActionResult<IEnumerable<VwDepartmentCourseCount>>> GetDepartmentCourseCount()
        {
            return await _context.VwDepartmentCourseCount.FromSqlRaw("SELECT * FROM vwDepartmentCourseCount").ToListAsync();
        }

        // GET: api/Departments/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Department>> GetDepartment(int id)
        {
            var department = await FindDepartmentAsync(id);
            if (department == null)
            {
                return NotFound();
            }

            return department;
        }

        // PUT: api/Departments/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutDepartment(int id, PutDepartmentVM input)
        {
            //var department = await _context.Department.FindAsync(id);
            //if (department == null)
            //{
            //    return NotFound();
            //}

            //// TODO: 如何接sp回傳值
            //await _spContext.Department_Update(id, input.Name, input.Budget, input.StartDate, input.InstructorId, department.RowVersion);

            //return NoContent();

            var department = await FindDepartmentAsync(id);
            if (department == null)
            {
                return NotFound();
            }

            department.InjectFrom(input);

            await _context.SaveChangesAsync();

            return NoContent();
        }

        // POST: api/Departments
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<IActionResult> PostDepartment(PostDepartmentVM input)
        {
            // TODO: 如何接sp回傳值
            await _spContext.Department_Insert(input.Name, input.Budget, input.StartDate, input.InstructorId);

            return NoContent();
        }

        // DELETE: api/Departments/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteDepartment(int id)
        {
            var department = await FindDepartmentAsync(id);
            if (department == null)
            {
                return NotFound();
            }

            department.IsDeleted = true;

            await _context.SaveChangesAsync();

            return NoContent();
        }

        private async Task<Department> FindDepartmentAsync(int id)
        {
            return await _context.Department.SingleOrDefaultAsync(x => x.DepartmentId == id && x.IsDeleted != true);
        }
    }
}
