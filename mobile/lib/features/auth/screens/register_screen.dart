import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile/core/constants/colors.dart';
import 'package:mobile/core/constants/image_strings.dart';
import 'package:mobile/core/constants/sizes.dart';
import 'package:mobile/features/auth/bloc/auth_event.dart';
import 'package:mobile/features/auth/bloc/auth_state.dart';
import '../bloc/auth_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _obscurePassword = ValueNotifier<bool>(true);
  final _obscureConfirmPassword = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthRegister(
              _usernameController.text.trim(),
              _emailController.text.trim(),
              _passwordController.text.trim(),
              _fullNameController.text.trim().isEmpty
                  ? null
                  : _fullNameController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(),
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
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create an account',
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              SizedBox(height: TSizes.spaceBtwSections),

              // Form
              _buildForm(context),

              // Divider
              _buildDivider(isDark, context),
              SizedBox(height: TSizes.spaceBtwSections),

              // Google Button
              _buildGoogleButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // FULL NAME
          TextFormField(
            controller: _fullNameController,
            decoration: const InputDecoration(
              labelText: 'Nama Lengkap',
              prefixIcon: Icon(Iconsax.user),
            ),
            validator: (value) => value == null || value.isEmpty
                ? 'Nama lengkap harus diisi'
                : null,
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // USERNAME
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              prefixIcon: Icon(Iconsax.user_edit),
            ),
            validator: (value) => value == null || value.isEmpty
                ? 'Nama pengguna harus diisi'
                : null,
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // email
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Iconsax.direct),
            ),
            validator: (value) {
              final bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value ?? '');
              if (value == null || value.isEmpty) {
                return 'Email harus diisi';
              }
              if (!emailValid) {
                'Masukkan email yang valid';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // password
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword.value,
            decoration: InputDecoration(
              labelText: 'Kata Sandi',
              prefixIcon: const Icon(Iconsax.password_check),
              suffixIcon: IconButton(
                  icon: Icon(
                      _obscurePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                  onPressed: () {
                    setState(() {
                      _obscurePassword.value = !_obscurePassword.value;
                    });
                  }),
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
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // ulang password
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword.value,
            decoration: InputDecoration(
              labelText: 'Konfirmasi Kata Sandi',
              prefixIcon: const Icon(Iconsax.password_check),
              suffixIcon: IconButton(
                  icon: Icon(_obscureConfirmPassword.value
                      ? Iconsax.eye_slash
                      : Iconsax.eye),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword.value =
                          !_obscureConfirmPassword.value;
                    });
                  }),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Konfirmasi kata sandi harus diisi';
              }
              if (value != _passwordController.text) {
                return 'Kata sandi tidak cocok';
              }
              return null;
            },
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          // register button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _register,
              child: const Text('Daftar'),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
        ],
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
          'atau daftar dengan',
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
