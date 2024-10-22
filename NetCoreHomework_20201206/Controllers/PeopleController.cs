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
    public class PeopleController : ControllerBase
    {
        private readonly ContosoUniversityContext _context;

        public PeopleController(ContosoUniversityContext context)
        {
            _context = context;
        }

        // GET: api/People
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Person>>> GetPerson()
        {
            return await _context.Person.Where(x => x.IsDeleted != true).ToListAsync();
        }

        // GET: api/People/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Person>> GetPerson(int id)
        {
            var person = await FindPersonAsync(id);
            if (person == null)
            {
                return NotFound();
            }

            return person;
        }

        // PUT: api/People/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutPerson(int id, PutPersonVM input)
        {
            var person = await FindPersonAsync(id);
            if (person == null)
            {
                return NotFound();
            }

            person.InjectFrom(input);

            await _context.SaveChangesAsync();

            return NoContent();
        }

        // POST: api/People
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Person>> PostPerson(Person person)
        {
            _context.Person.Add(person);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetPerson", new { id = person.Id }, person);
        }

        // DELETE: api/People/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletePerson(int id)
        {
            var person = await FindPersonAsync(id);
            if (person == null)
            {
                return NotFound();
            }

            person.IsDeleted = true;

            await _context.SaveChangesAsync();

            return NoContent();
        }

        private async Task<Person> FindPersonAsync(int id)
        {
            return await _context.Person.SingleOrDefaultAsync(x => x.Id == id && x.IsDeleted != true);
        }
    }
}
