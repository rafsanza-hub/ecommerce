const User = require('./user.model');

class UserService {
  async getUserById(userId) {
    const user = await User.findById(userId);
    if (!user) throw new Error('User not found');
    return user;
  }

  // Fungsi tambahan di masa depan (misalnya update profil)
  async updateUser(userId, updates) {
    const user = await User.findByIdAndUpdate(userId, updates, { new: true, runValidators: true });
    if (!user) throw new Error('User not found');
    return user;
  }
}

module.exports = new UserService();