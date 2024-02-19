---
title: Customizing login page in Filament 3
date: 2023-10-16 17:25 +0530
categories: [Development, Laravel]
tags: [coding, php, laravel, filamentphp]
---
# Customizing login page in Filament 3

By default, the [Filament](https://filamentphp.com/) login form contains email and password fields. To customize the login page, overwrite the default filament login page based on requirements.

All Filament Panels settings are made in the Service Provider. For this example, we will use the default `AdminPanelProvider`. Here we have a `login()` method which accepts an action class as a parameter:

```php
# File: app/Providers/Filament/AdminPanelProvider.php
use app/Filament/Auth/Login;

class AdminPanelProvider extends PanelProvider
{
	public function panel(Panel $panel): Panel
	{
		return $panel
			->default()
			->id('admin')
			->path('admin')
			->login(Login::class) // Custom login page
			// ...
	}
}
```

Let's create own `Login` page and inject it into a `login` method. Create a new class in the `App\Filament\Auth` directory. It needs to extend the original `Login` class from the Filament.

```php
# File: app/Filament/Auth/Login.php
use Filament\Pages\Auth\Login as BaseAuth;

class Login extends BaseAuth
{
	/**
	 * @return array<int | string, string | Form>
	 */
	protected function getForms(): array
	{
		return [
			'form' => $this->form(
				$this->makeForm()
					->schema([]) // schema() is responsible for displaying forms
					->statePath('data'),
			),
		];
	}
}
```

Now, let's overwrite the `getFormActions()` method to add SSO buttons for authenticating.

```php
# File: app/Filament/Auth/Login.php
use Filament\Pages\Auth\Login as BaseAuth;
use Filament\Actions\Action;
use Filament\Actions\ActionGroup;

class Login extends BaseAuth
{
	/**
     * @return array<Action | ActionGroup>
     */
    protected function getFormActions(): array
    {
        return [
            $this->getGoogleAuthAction(),
        ];
    }

	/**
	 * @return Action
	 */
	protected function getGoogleAuthAction(): Action
    {
        return Action::make('google-auth')
            ->label('Google Login')
            ->url('/auth/google/redirect');
    }
}
```

To customize the heading of login page, you can overwrite the `getHeading()` method. This accept `string|Htmlable` as return value, so you can customize the heading with raw `HTML` content like this,

> [!WARNING]  
> HTML contents are styled with Tailwindcss. Make sure to install Tailwindcss in the project and build the project CSS files

```php
# File: app/Filament/Auth/Login.php
use Filament\Pages\Auth\Login as BaseAuth;
use Illuminate\Contracts\Support\Htmlable;
use Illuminate\Support\Facades\Session;
use Illuminate\Support\HtmlString;

class Login extends BaseAuth
{
	/**
	 * @return string|Htmlable
	 */
	public function getHeading(): string|Htmlable
    {
        return new HtmlString('
            <div class="flex items-center flex-col pt-4">
                <h1 class="text-2xl font-normal">Welcome Back!</h1>
                <img class="pt-4" src="'.asset('images/logo.png').'" alt="Logo!" width="300" height="300">
                '.
                (
                    Session::has('error') ?
                        '<h5 class="text-red-500 text-base font-normal pt-4">'.Session::get('error').'</h5>'
                        : ''
                )
                .'
            </div>
            <!-- Script to set default theme to dark -->
            <!-- <script>
                localStorage.setItem("theme", "dark");
            </script> -->
        ');
    }
}
```

Here, Laravel `Session` is used to get the errors during authentication process and display the errors as `HTML` output. Make sure to follow the below procedure to throw errors in login page.

```php
return redirect('/login')->with('error', 'Login failed, please try again.');
```

