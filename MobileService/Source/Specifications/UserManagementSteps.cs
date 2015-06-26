using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using NUnit.Framework;
using TechTalk.SpecFlow;

namespace Specifications
{
    [Binding]
    public class UserManagementSteps
    {
        private readonly UserContext _context = new UserContext();
        private readonly HttpClient _httpClient = new HttpClient();

        [Given(@"I am an administrator for user management application")]
        public void GivenIAmAnAdministratorForUserManagementApplication()
        {
            _httpClient.DefaultRequestHeaders.Add("X-ZUMO-APPLICATION", "");
        }

        [When(@"I request all users")]
        public void WhenIRequestAllUsers()
        {
            _context.Result = Task.Run(() => _httpClient.GetAsync("https://tc.azure-mobile.net/api/user")).Result;
        }

        [Then(@"I receive a (.*) Http Status Code")]
        public void ThenIRecieveAHttpStatusCode(int p0)
        {
            Assert.AreEqual(p0, (int) _context.Result.StatusCode);
        }

        [Given(@"I have a new user")]
        public void GivenIHaveANewUser()
        {
            _context.User = new
            {
                Id = "1",
                Name = "user name",
                Email = "user@email.com"
            };
        }

        [When(@"I create a new user")]
        public void WhenICreateANewUser()
        {
            var userJson = JsonConvert.SerializeObject(_context.User);
            _context.Result =
                Task.Run(
                    () =>
                        _httpClient.PostAsync("https://tc.azure-mobile.net/api/user",
                            new StringContent(userJson, Encoding.UTF8, "application/json")))
                    .Result;
        }
    }
}