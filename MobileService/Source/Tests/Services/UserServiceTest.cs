using Common;
using UserManagement.Controllers;
using UserManagement.Services;
using Xunit;

namespace Tests.Services
{
    public class UserServiceTest
    {
        private readonly IUserService _userService = new UserService();

        public UserServiceTest()
        {
            _userService.AddUser(new User
            {
                Id = 1,
                Name = "user name 1"
            });
        }

        [Fact]
        public void GetUsers_ShouldReturnUsers()
        {
            Assert.True(_userService.GetUsers().Count > 0);
        }

        [Fact]
        public void AddUser_ShouldAddUser()
        {
            var totalUsers = _userService.GetUsers().Count;
            _userService.AddUser(new User
            {
                Id = 2,
                Name = "user name 2"
            });

            Assert.Equal(totalUsers + 1, _userService.GetUsers().Count);
        }

        [Fact]
        public void GetUserById_ShouldReturnUser()
        {
            _userService.AddUser(new User
            {
                Id = 3,
                Name = "my user"
            });

            var user = _userService.GetUserById(3);

            Assert.Equal("my user", user.Name);
        }
    }
}