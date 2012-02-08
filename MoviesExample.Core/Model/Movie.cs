using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel.DataAnnotations;

namespace MoviesExample.Core.Model
{
    [DisplayColumn("Title")]
    public partial class Movie : PersistentEntity
    {
        [Required]
        [MinLength(2)]
        [MaxLength(50)]
        public string Title { get; set; }

        public int DirectorId { get; set; }

        [ForeignKey("DirectorId")]
        public virtual Director Director { get; set; }
    }
}
