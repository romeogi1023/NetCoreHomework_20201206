using Microsoft.EntityFrameworkCore;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace NetCoreHomework_20201206.Models
{
    public partial class ContosoUniversityContext : DbContext
    {
        public override Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
        {
            var entities = this.ChangeTracker.Entries();

            foreach (var entry in entities)
            {
                if (entry.State == EntityState.Modified)
                {
                    entry.CurrentValues.SetValues(new { DateModified = DateTime.Now });
                }
            }

            return base.SaveChangesAsync(cancellationToken);
        }
    }
}
