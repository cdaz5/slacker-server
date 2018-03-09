/* eslint-disable */
import axios from 'axios';

describe('user resolvers', () => {
	test('allUsers', async () => {
		const response = await axios.post('http://localhost:3000/graphql', {
			query: `
        query {
          allUsers {
            id
            username
            email
          }
        }
      `,
		});
		const { data } = response;
		expect(data).toMatchObject({
			data: {
				allUsers: [],
			},
		});
	});

	test('createUser', async () => {
		const response = await axios.post('http://localhost:3000/graphql', {
			mutation: `
        mutation {
          register(username: "test", email: "test@gmail.com", password: "password") { 
            ok
            user {
              username
              email
            }
            errors {
              path
              message
            }
          }
        }
      `,
		});
		const { data } = response;
		expect(data).toMatchObject({
			data: {
				register: {
					ok: true,
					user: {
						username: 'test',
						email: 'test@gmail.com',
					},
					errors: null,
				},
			},
		});
	});
});
