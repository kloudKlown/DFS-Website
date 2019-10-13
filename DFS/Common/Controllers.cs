using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace DFS.UI.Common
{
    public class Controllers 
    {

        public Controllers()
        {

        }

        public Controllers(string value)
        {
            Value = value;
        }

        public string Value { get; set; }

        public string Url
        {
            get
            {
                return $"/{Value}";
            }
        }
    }
}
