using System.Collections.Generic;
using Common;

namespace UserManagement.Services
{
    public interface IUserService
    {
        List<User> GetUsers();
        User GetUserById(int userId);
        void AddUser(User user);
    }
}