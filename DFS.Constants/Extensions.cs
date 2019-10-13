using System;
using System.Collections.Generic;
using System.Text;

namespace DFS.Common
{
    public static class Extensions
    {

        public static class DateExtensions
        {
            public static DateTime DateTimeMinAllowed
            {
                get
                {
                    return new DateTime(2016, 1, 1);
                }
            }
        }

    }
}
