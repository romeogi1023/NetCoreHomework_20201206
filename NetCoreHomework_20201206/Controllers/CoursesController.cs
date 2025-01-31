﻿using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using NetCoreHomework_20201206.Models;
using NetCoreHomework_20201206.ViewModel;
using Omu.ValueInjecter;

namespace NetCoreHomework_20201206.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CoursesController : ControllerBase
    {
        private readonly ContosoUniversityContext _context;

        public CoursesController(ContosoUniversityContext context)
        {
            _context = context;
        }

        // GET: api/Courses
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Course>>> GetCourse()
        {
            return await _context.Course.Where(x => x.IsDeleted != true).ToListAsync();
        }

        // GET: api/Courses/CourseStudents
        [HttpGet("CourseStudents")]
        public async Task<ActionResult<IEnumerable<VwCourseStudents>>> GetCourseStudents()
        {
            return await _context.VwCourseStudents.FromSqlInterpolated($@"SELECT * FROM vwCourseStudents").ToListAsync();
        }

        // GET: api/Courses/CourseStudentCount
        [HttpGet("CourseStudentCount")]
        public async Task<ActionResult<IEnumerable<VwCourseStudentCount>>> GetCourseStudentCount()
        {
            return await _context.VwCourseStudentCount.FromSqlInterpolated($@"SELECT * FROM vwCourseStudentCount").ToListAsync();
        }

        // GET: api/Courses/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Course>> GetCourse(int id)
        {
            var course = await FindCourseAsync(id);
            if (course == null)
            {
                return NotFound();
            }

            return course;
        }

        // PUT: api/Courses/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutCourse(int id, PutCourseVM input)
        {
            var course = await FindCourseAsync(id);
            if (course == null)
            {
                return NotFound();
            }

            course.InjectFrom(input);

            await _context.SaveChangesAsync();

            return NoContent();
        }

        // POST: api/Courses
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Course>> PostCourse(Course course)
        {
            _context.Course.Add(course);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetCourse", new { id = course.CourseId }, course);
        }

        // DELETE: api/Courses/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCourse(int id)
        {
            var course = await FindCourseAsync(id);
            if (course == null)
            {
                return NotFound();
            }

            course.IsDeleted = true;

            await _context.SaveChangesAsync();

            return NoContent();
        }

        private async Task<Course> FindCourseAsync(int id)
        {
            return await _context.Course.SingleOrDefaultAsync(x => x.CourseId == id && x.IsDeleted != true);
        }
    }
}
