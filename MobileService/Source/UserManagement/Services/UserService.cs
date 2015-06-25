using System.Collections.Generic;
using System.Linq;
using Common;

namespace UserManagement.Services
{
    public class UserService : IUserService
    {

        private readonly List<User> _users = new List<User>(); 
        #region Implementation of IUserService

        public List<User> GetUsers()
        {
            return _users;
        }

        public User GetUserById(int userId)
        {
            return _users.FirstOrDefault(user => user.Id == userId);
        }

        public void AddUser(User user)
        {
            _users.Add(user);
        }

        #endregion
    }
}