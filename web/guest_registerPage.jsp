<%@page import="com.ebutler.swp.dto.ProviderDTO"%>
<%@page import="com.ebutler.swp.dto.CustomerDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.ebutler.swp.dto.RoleDTO"%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <title>E-Butler</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="" name="keywords">
        <meta content="" name="description">

        <!-- Icon FontAwesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css"/>

        <!-- Google Web Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600&family=Inter:wght@700;800&display=swap" rel="stylesheet">

        <!-- Icon Font Stylesheet -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Libraries Stylesheet -->
        <link href="lib/animate/animate.min.css" rel="stylesheet">
        <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

        <!-- Customized Bootstrap Stylesheet -->
        <link href="css/bootstrap.min.css" rel="stylesheet">

        <!-- Template Stylesheet -->
        <link href="css/style.css" rel="stylesheet">
        <link rel="stylesheet" href="css/guestPage.css">
        <link rel="stylesheet" href="css/base.css">
    </head>

    <body>
        <%
            ArrayList<RoleDTO> role_list = (ArrayList<RoleDTO>) request.getAttribute("ROLE_LIST");

            CustomerDTO customer = (CustomerDTO) request.getAttribute("CUS_INFO");
            CustomerDTO customerError = (CustomerDTO) request.getAttribute("CUS_ERROR");
            ProviderDTO provider = (ProviderDTO) request.getAttribute("PRO_INFO");
            ProviderDTO providerError = (ProviderDTO) request.getAttribute("PRO_ERROR");
            String role_id = (String) request.getAttribute("ROLE_ID");

            customerError = (customerError == null) ? new CustomerDTO() : customerError;
            providerError = (providerError == null) ? new ProviderDTO() : providerError;
            customer = (customer == null) ? new CustomerDTO() : customer;
            provider = (provider == null) ? new ProviderDTO() : provider;
            role_id = (role_id == null) ? "" : role_id;
            role_list = (role_list == null) ? new ArrayList<RoleDTO>() : role_list; 

            String class_Hide = "hide";
        %>
        <div class="container-xxl bg-white p-0">
            <!-- Spinner Start -->
            <div id="spinner" class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
                <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
                    <span class="sr-only">Loading...</span>
                </div>
            </div>
            <!-- Spinner End -->


            <!-- Navbar Start -->
            <div class="container-fluid nav-bar bg-transparent">
                <nav style="justify-content: center" class="navbar navbar-expand-lg bg-white navbar-light py-0 px-4">
                    <a href="guest_landingPage.jsp" class="navbar-brand d-flex align-items-center text-center">
                        <div class="p-2 me-2">
                            <img class="img-fluid" src="img/logo.png" alt="Icon" style="width: 40px; height: 40px;">
                        </div>
                        <h1 class="m-0 text-primary">E-Butler</h1>
                    </a>
                </nav>
            </div>
            <!-- Navbar End -->


            <!-- Header Start -->
            <div class="container-fluid bg-white p-0">
                <div class="slider row g-0 align-items-center flex-column-reverse flex-md-row">

                    <div class="col-md-0 col-lg-1 col-sm-0 animated fadeIn"></div>

                    <div class="col-md-4 col-lg-4 col-sm-0 animated fadeIn website-logo">
                        <img style="transform: scaleX(-1)" class="slider-img" src="https://www.e-butler.com/wp-content/uploads/2022/01/14-1.png" alt="">
                    </div>

                    <div class="col-md-1 col-lg-1 col-sm-0 animated fadeIn"></div>

                    <div class="col-lg-6 col-md-10 col-sm-12 animated fadeInUp">
                        <!-- Register Form Start -->
                        <div class="auth-form">
                            <div class="Register-form Selection-role-form <%if (!role_id.isEmpty()) {%><%=class_Hide%><% } %>">
                                <div class="auth-form__header flex-between">
                                    <a href="guest_landingPage.jsp" style="cursor: pointer;" class="back-register-form">
                                        <i class="fa-solid fa-arrow-left"></i>
                                    </a>
                                    <div class="auth-form__header">
                                        <h3 class="auth-form__heading">As a member?</h3>
                                        <form action="MainController" method="POST">
                                            <button type="submit" class="dropdown-item login--link auth-form__heading auth-form__switch-btn">Login</button>
                                            <input value="Login" name="action" type="hidden">
                                            <input value="false" name="isLogin" type="hidden">
                                        </form>
                                    </div>
                                </div>

                                <!-- USER ROLE Start -->
                                <%                                    for (RoleDTO role : role_list) {
                                %>
                                <div id="<%=role.getId()%>" class="selection-role-item m-12 flex-md-row">
                                    <div class="selection-role-name col-md-3 p-4">
                                        <%
                                            if (role.getId().equals("CUS")) %><i class="fa-sharp fa-solid fa-users"></i><%
                                                if (role.getId().equals("PRO")) %><i class="fa-solid fa-building"></i><%
                                            %>
                                        <h5 style="color: var(--primary-color)" class="txt-lg"><%=role.getName()%></h5>
                                    </div>
                                    <div class="selection-role-description col-md-8 px-4">
                                        <h5 style="color: var(--primary-color)" class="txt-lg">Description</h5>
                                        <p class="txt-sm"><%=role.getDescription()%></p>
                                    </div>
                                    <div class="selection-role-next col-md-1">
                                        <i class="fa-solid fa-arrow-right-from-bracket"></i>
                                    </div>
                                </div>
                                <%
                                    }
                                %>
                                <!-- USER ROLE End -->      
                            </div>

                            <!-- Customer Form -->
                            <div id="register-form-customer" class="Register-form auth-form <%if (!role_id.equals("CUS")) {%><%=class_Hide%><% }%>">
                                <div class="auth-form__header flex-between">
                                    <a href="MainController?action=Register" style="margin-left: 2rem; cursor: pointer;" class="back-register-form">
                                        <i class="fa-solid fa-arrow-left"></i>
                                    </a>
                                    <div class="auth-form__header">
                                        <h3 class="auth-form__heading">As a member?</h3>
                                        <form action="MainController" method="POST">
                                            <button type="submit" class="dropdown-item login--link auth-form__heading auth-form__switch-btn">Login</button>
                                            <input value="Login" name="action" type="hidden">
                                            <input value="false" name="isLogin" type="hidden">
                                        </form>
                                    </div>
                                </div>

                                <div class="auth-form__body">
                                    <form action="MainController" method="POST">
                                        <input type="hidden" name="action" value="Register">
                                        <input type="hidden" name="isRegister" value="true">
                                        <input type="hidden" name="role_id" value="CUS">
                                        <div class="auth-form__form">
                                            <div class="auth-form__title">
                                                <p>Be member of E-Butler</p>
                                            </div>

                                            <div class="auth-form__social-connection">
                                                <a href="" class="btn btn--with-icon--google social-connection__item">
                                                    <i class="fa-brands fa-google icon--google"></i>
                                                    <span class="auth-form__social-connection__title">
                                                        Connect to Google
                                                    </span> 
                                                </a>
                                            </div>

                                            <div class="auth-form__block row">
                                                <div class="auth-form__group col l-6">
                                                    <input name="name" class="auth-form__input border-bottom m-y-0" required="" value="<%=customer.getName()%>" placeholder="Full Name">
                                                    <div class="auth-form__aside">
                                                        <%
                                                            if (!customerError.getName().isEmpty()) {
                                                        %>
                                                        <span class="auth-form__notify">
                                                            <i class="fa-solid fa-triangle-exclamation"></i>
                                                            <p><%=customerError.getName()%></p>
                                                        </span> 
                                                        <%
                                                            }
                                                        %>
                                                    </div>
                                                </div>
                                                <div class="auth-form__group col l-6">
                                                    <input name="username" class="auth-form__input border-bottom m-y-0" required="" value="<%=customer.getUsername()%>" placeholder="User Name">
                                                    <div class="auth-form__aside">
                                                        <%
                                                            if (!customerError.getUsername().isEmpty()) {
                                                        %>
                                                        <span class="auth-form__notify">
                                                            <i class="fa-solid fa-triangle-exclamation"></i>
                                                            <p><%=customerError.getUsername()%></p>
                                                        </span> 
                                                        <%
                                                            }
                                                        %>

                                                    </div>
                                                </div>
                                            </div>

                                            <div class="auth-form__group">
                                                <input type="email" name="email" class="auth-form__input border-bottom m-y-0" required="" value="<%=customer.getEmail()%>" placeholder="Email">
                                                <div class="auth-form__aside">
                                                    <%
                                                        if (!customerError.getEmail().isEmpty()) {
                                                    %>
                                                    <span class="auth-form__notify">
                                                        <i class="fa-solid fa-triangle-exclamation"></i>
                                                        <p><%=customerError.getEmail()%></p>
                                                    </span> 
                                                    <%
                                                        }
                                                    %>

                                                </div>
                                            </div>

                                            <div class="auth-form__group">
                                                <input type="tel" name="phone" class="auth-form__input border-bottom m-y-0" required="" value="<%=customer.getPhone()%>" placeholder="Phone">
                                                <div class="auth-form__aside">
                                                    <%
                                                        if (!customerError.getPhone().isEmpty()) {
                                                    %>
                                                    <span class="auth-form__notify">
                                                        <i class="fa-solid fa-triangle-exclamation"></i>
                                                        <p><%=customerError.getPhone()%></p>
                                                    </span> 
                                                    <%
                                                        }
                                                    %>

                                                </div>
                                            </div>

                                            <div class="flex-vetical-center m-y-0">
                                                <span class="auth-form__info">Gender</span>
                                                <select class="auth-form__selection border-bottom m-x-2" name="gender">
                                                    <option value="0" <%if(customer.getGender() == 0) {%>selected<%}%>>Male</option>
                                                    <option value="1" <%if(customer.getGender() == 1) {%>selected<%}%>>Female</option>
                                                    <option value="2" <%if(customer.getGender() == 2) {%>selected<%}%>>Option</option>
                                                </select>
                                            </div>

                                            <div class="auth-form__group">
                                                <span class="auth-form__info">Date of birth</span>
                                                <input type="date" name="dob" class="auth-form__input border-bottom m-y-0" required="" value="<%=customer.getDob()%>">
                                                <div class="auth-form__aside">
                                                    <%
                                                        if (!customerError.getDob().isEmpty()) {
                                                    %>
                                                    <span class="auth-form__notify">
                                                        <i class="fa-solid fa-triangle-exclamation"></i>
                                                        <p><%=customerError.getDob()%></p>
                                                    </span> 
                                                    <%
                                                        }
                                                    %>

                                                </div>
                                            </div>

                                            <div class="auth-form__group">
                                                <input name="password" type="password" class="auth-form__input border-bottom m-y-0" required="" placeholder="Password">
                                            </div>

                                            <div class="auth-form__group">
                                                <input name="confirm_password" type="password" class="auth-form__input border-bottom m-y-0" required="" placeholder="Confirm Password">
                                                <div class="auth-form__aside">
                                                    <%
                                                        if (!customerError.getPassword().isEmpty()) {
                                                    %>
                                                    <span class="auth-form__notify">
                                                        <i class="fa-solid fa-triangle-exclamation"></i>
                                                        <p><%=customerError.getPassword()%></p>
                                                    </span> 
                                                    <%
                                                        }
                                                    %>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="auth-form__aside m-y-1">
                                            <input type="checkbox" name="" class="policy-check-cus">
                                            <p class="auth-form__policy-text">By register you have accepted with E-Butler about
                                                <a href="" class="auth-form__policy-link">Services</a> &
                                                <a href="" class="auth-form__policy-link">Security Policy</a>
                                            </p>
                                        </div>

                                        <div class="auth-form__controls m-y-1">
                                            <button name="action" value="Register" id="btn-register" class="btn btn-size-s btn-primary btn--disable" disabled>Create Account</button>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <!-- Provider Form -->
                            <div id="register-form-provider" class="Register-form auth-form <%if (!role_id.equals("PRO")) {%><%=class_Hide%><% }%>">
                                <div class="auth-form__header flex-between">
                                    <a href="MainController?action=Register" style="margin-left: 2rem; cursor: pointer;" class="back-register-form">
                                        <i class="fa-solid fa-arrow-left"></i>
                                    </a>
                                    <div class="auth-form__header">
                                        <h3 class="auth-form__heading">As a member?</h3>
                                        <form action="MainController" method="POST">
                                            <button type="submit" class="dropdown-item login--link auth-form__heading auth-form__switch-btn">Login</button>
                                            <input value="Login" name="action" type="hidden">
                                            <input value="false" name="isLogin" type="hidden">
                                        </form>
                                    </div>
                                </div>

                                <div class="auth-form__body">
                                    <form action="MainController" method="POST">
                                        <input type="hidden" name="action" value="Register">
                                        <input type="hidden" name="isRegister" value="true">
                                        <input type="hidden" name="role_id" value="PRO">
                                        <div class="auth-form__form">
                                            <div class="auth-form__title">
                                                <p>Be member of E-Butler</p>
                                            </div>

                                            <div class="auth-form__social-connection">
                                                <a href="" class="btn btn--with-icon--google social-connection__item">
                                                    <i class="fa-brands fa-google icon--google"></i>
                                                    <span class="auth-form__social-connection__title">
                                                        Connect to Google
                                                    </span> 
                                                </a>
                                            </div>

                                            <div class="auth-form__block flex-between">
                                                <div class="auth-form__group">
                                                    <input name="name" class="auth-form__input border-bottom m-y-0" required="" value="<%=provider.getName()%>" placeholder="Name Of Company">
                                                    <div class="auth-form__aside">
                                                        <%
                                                            if (!providerError.getName().isEmpty()) {
                                                        %>
                                                        <span class="auth-form__notify">
                                                            <i class="fa-solid fa-triangle-exclamation"></i>
                                                            <p><%=providerError.getName()%></p>
                                                        </span> 
                                                        <%
                                                            }
                                                        %>
                                                    </div>
                                                </div>
                                                <div class="auth-form__group">
                                                    <input name="username" class="auth-form__input border-bottom m-y-0" required="" value="<%=provider.getUsername()%>" placeholder="User Name">
                                                    <div class="auth-form__aside">
                                                        <%
                                                            if (!providerError.getUsername().isEmpty()) {
                                                        %>
                                                        <span class="auth-form__notify">
                                                            <i class="fa-solid fa-triangle-exclamation"></i>
                                                            <p><%=providerError.getUsername()%></p>
                                                        </span> 
                                                        <%
                                                            }
                                                        %>

                                                    </div>
                                                </div>
                                            </div>

                                            <div class="auth-form__group">
                                                <input type="email" name="email" class="auth-form__input border-bottom m-y-0" required="" value="<%=provider.getEmail()%>" placeholder="Email">
                                                <div class="auth-form__aside">
                                                    <%
                                                        if (!providerError.getEmail().isEmpty()) {
                                                    %>
                                                    <span class="auth-form__notify">
                                                        <i class="fa-solid fa-triangle-exclamation"></i>
                                                        <p><%=providerError.getEmail()%></p>
                                                    </span> 
                                                    <%
                                                        }
                                                    %>

                                                </div>
                                            </div>

                                            <div class="auth-form__group">
                                                <input type="tel" name="phone" class="auth-form__input border-bottom m-y-0" required="" value="<%=provider.getPhone()%>" placeholder="Phone">
                                                <div class="auth-form__aside">
                                                    <%
                                                        if (!providerError.getPhone().isEmpty()) {
                                                    %>
                                                    <span class="auth-form__notify">
                                                        <i class="fa-solid fa-triangle-exclamation"></i>
                                                        <p><%=providerError.getPhone()%></p>
                                                    </span> 
                                                    <%
                                                        }
                                                    %>

                                                </div>
                                            </div>

                                            <div class="auth-form__group">
                                                <input name="password" type="password" class="auth-form__input border-bottom m-y-0" required="" placeholder="Password">
                                            </div>

                                            <div class="auth-form__group">
                                                <input name="confirm_password" type="password" class="auth-form__input border-bottom m-y-0" required="" placeholder="Confirm Password">
                                                <div class="auth-form__aside">
                                                    <%
                                                        if (!providerError.getPassword().isEmpty()) {
                                                    %>
                                                    <span class="auth-form__notify">
                                                        <i class="fa-solid fa-triangle-exclamation"></i>
                                                        <p><%=providerError.getPassword()%></p>
                                                    </span> 
                                                    <%
                                                        }
                                                    %>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="auth-form__aside m-y-1">
                                            <input type="checkbox" name="" class="policy-check-pro">
                                            <p class="auth-form__policy-text">By register you have accepted with E-Butler about
                                                <a href="" class="auth-form__policy-link">Services</a> &
                                                <a href="" class="auth-form__policy-link">Security Policy</a>
                                            </p>
                                        </div>

                                        <div class="auth-form__controls m-y-1">
                                            <button name="action" value="Register" id="btn-register" class="btn btn-size-s btn-primary">Create Account</button>
                                        </div>
                                    </form>
                                </div>
                            </div>

                        </div>
                        <!-- Register Form End -->
                    </div>
                </div>
            </div>
            <!-- Header End -->

            <!-- Footer Start -->
            <div class="container-fluid bg-dark text-white-50 footer pt-5  wow fadeIn" data-wow-delay="0.1s">
                <div class="container py-5">
                    <div class="row g-5">
                        <div class="col-lg-3 col-md-6">
                            <h5 class="text-white mb-4">Get In Touch</h5>
                            <p class="mb-2"><i class="fa fa-map-marker-alt me-3"></i>E2a-7, D1 Street, Long Thanh
                                My, Thu Duc District, Ho Chi Minh City</p>
                            <p class="mb-2"><i class="fa fa-phone-alt me-3"></i>+012 345 67890</p>
                            <p class="mb-2"><i class="fa fa-envelope me-3"></i>SE1111@e-butler.com</p>
                            <div class="d-flex pt-2">
                                <a class="btn btn-outline-light btn-social" href=""><i class="fab fa-twitter"></i></a>
                                <a class="btn btn-outline-light btn-social" href=""><i class="fab fa-facebook-f"></i></a>
                                <a class="btn btn-outline-light btn-social" href=""><i class="fab fa-youtube"></i></a>
                                <a class="btn btn-outline-light btn-social" href=""><i class="fab fa-linkedin-in"></i></a>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <h5 class="text-white mb-4">Quick Links</h5>
                            <a class="btn btn-link text-white-50" href="">About Us</a>
                            <a class="btn btn-link text-white-50" href="">Contact Us</a>
                            <a class="btn btn-link text-white-50" href="">Our Services</a>
                            <a class="btn btn-link text-white-50" href="">Privacy Policy</a>
                            <a class="btn btn-link text-white-50" href="">Terms & Condition</a>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <h5 class="text-white mb-4">Photo Gallery</h5>
                            <div class="row g-2 pt-2">
                                <div class="col-4">
                                    <img class="img-fluid rounded bg-light p-1"
                                         src="https://cf.shopee.vn/file/d4bbea4570b93bfd5fc652ca82a262a8" alt="">
                                </div>
                                <div class="col-4">
                                    <img class="img-fluid rounded bg-light p-1"
                                         src="https://cf.shopee.vn/file/a0a9062ebe19b45c1ae0506f16af5c16" alt="">
                                </div>
                                <div class="col-4">
                                    <img class="img-fluid rounded bg-light p-1"
                                         src="https://cf.shopee.vn/file/38fd98e55806c3b2e4535c4e4a6c4c08" alt="">
                                </div>
                                <div class="col-4">
                                    <img class="img-fluid rounded bg-light p-1"
                                         src="https://cf.shopee.vn/file/2c46b83d84111ddc32cfd3b5995d9281" alt="">
                                </div>
                                <div class="col-4">
                                    <img class="img-fluid rounded bg-light p-1"
                                         src="https://cf.shopee.vn/file/77bf96a871418fbc21cc63dd39fb5f15" alt="">
                                </div>
                                <div class="col-4">
                                    <img class="img-fluid rounded bg-light p-1"
                                         src="https://cf.shopee.vn/file/3900aefbf52b1c180ba66e5ec91190e5" alt="">
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <h5 class="text-white mb-4">Newsletter</h5>
                            <p>Dolor amet sit justo amet elitr clita ipsum elitr est.</p>
                            <div class="position-relative mx-auto" style="max-width: 400px;">
                                <input class="form-control bg-transparent w-100 py-3 ps-4 pe-5" type="text"
                                       placeholder="Your email">
                                <button type="button"
                                        class="btn btn-primary py-2 position-absolute top-0 end-0 mt-2 me-2">SignUp</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Footer End -->


            <!-- Back to Top -->
            <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i class="bi bi-arrow-up"></i></a>
        </div>

        <!-- JavaScript Libraries -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="lib/wow/wow.min.js"></script>
        <script src="lib/easing/easing.min.js"></script>
        <script src="lib/waypoints/waypoints.min.js"></script>
        <script src="lib/owlcarousel/owl.carousel.min.js"></script>

        <!-- Template Javascript -->
        <script src="js/main.js"></script>

        <!-- Javascript -->
        <script src="js/register.js"></script>
    </body>

</html>