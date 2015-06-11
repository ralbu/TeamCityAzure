using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Common;
using UserManagement.Services;

namespace UserManagement.Controllers
{
    public class UserController : ApiController
    {
        private readonly IUserService _userService; 

        public UserController(IUserService userService)
        {
            _userService = userService;
        }

        public HttpResponseMessage Get()
        {
            return Request.CreateResponse(_userService.GetUsers());
        }

        public HttpResponseMessage Get(int id)
        {
            return Request.CreateResponse(_userService.GetUserById(id));
        }

        public HttpResponseMessage Post(User user)
        {
            _userService.AddUser(user);

            var response = Request.CreateResponse(HttpStatusCode.Created, user);

            var host = Request.Headers.Host;
            response.Headers.Location = new Uri(String.Format("{0}/api/user/{1}", host, user.Id));

            return response;
        }
         
    }
}