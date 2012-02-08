using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel.DataAnnotations;

namespace MoviesExample.Core.Model
{
    [DisplayColumn("Name")]
    public partial class Director : PersistentEntity
    {
        [Required]
        [MinLength(2)]
        [MaxLength(50)]
        public string Name { get; set; }

        public virtual ICollection<Movie> Movies { get; set; }
    }
}
