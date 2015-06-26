using System.Net.Http;

namespace Specifications
{
    public class UserContext
    {
        public HttpResponseMessage Result { get; set; }
        public object User { get; set; }
    }
}