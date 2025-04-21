import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile/core/constants/colors.dart';
import 'package:mobile/core/constants/image_strings.dart';
import 'package:mobile/core/constants/sizes.dart';
import 'package:mobile/core/constants/spacing_style.dart';
import 'package:mobile/features/auth/bloc/auth_event.dart';
import 'package:mobile/features/auth/bloc/auth_state.dart';
import '../bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _obscurePassword = ValueNotifier<bool>(true);
  final _usernameOrEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthLogin(
              _usernameOrEmailController.text.trim(),
              _passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red));
          } else if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        child: Padding(
          padding: SpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              _buildHeader(isDark, context),
              _buildLoginForm(context),
              _buildDivider(isDark, context),
              SizedBox(height: TSizes.spaceBtwSections),
              _buildGoogleButton(),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildHeader(bool isDark, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          height: 150,
          image:
              AssetImage(isDark ? TImages.lightAppLogo : TImages.darkAppLogo),
        ),
        Text(
          'Masuk ke Akun Anda',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: TSizes.sm),
        Text(
          'Selamat datang kembali! Masukkan detail Anda untuk melanjutkan.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildLoginForm(context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            // Email Field
            TextFormField(
              controller: _usernameOrEmailController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.direct_right),
                labelText: 'Email',
              ),
              validator: (value) {
                // final bool emailValid = RegExp(
                //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                //     .hasMatch(value ?? '');
                if (value == null || value.trim().isEmpty) {
                  return 'Email atau Username harus diisi';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // input password
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword.value,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.password_check),
                labelText: 'Kata Sandi',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword.value ? Iconsax.eye_slash : Iconsax.eye,
                  ),
                  onPressed: () =>
                      _obscurePassword.value = !_obscurePassword.value,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kata sandi harus diisi';
                }
                if (value.length < 6) {
                  return 'Kata sandi harus minimal 6 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),

            // forgot password
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text('Lupa Kata Sandi?'),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections / 2),

            // button login
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _login();
                },
                child: Text('Masuk'),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // button buat akun
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: Text('Buat Akun'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(bool dark, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Divider(
            color: dark ? TColors.darkGrey : TColors.grey,
            thickness: 0.5,
            indent: 60,
            endIndent: 5,
          ),
        ),
        Text(
          'Atau Masuk Dengan',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        Flexible(
          child: Divider(
            color: dark ? TColors.darkGrey : TColors.grey,
            thickness: 0.5,
            indent: 5,
            endIndent: 60,
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // goggle
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: TColors.grey, width: 0.5),
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Image(
              width: TSizes.iconMd,
              height: TSizes.iconMd,
              image: AssetImage(TImages.google),
            ),
          ),
        ),
        const SizedBox(width: TSizes.spaceBtwItems),
      ],
    );
  }
}
