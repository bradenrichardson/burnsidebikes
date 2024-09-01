-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE maintenance ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE pricing ENABLE ROW LEVEL SECURITY;
ALTER TABLE discounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

-- Create a function to get the current user's role
CREATE OR REPLACE FUNCTION get_user_role()
RETURNS TEXT AS $$
  SELECT user_type FROM users WHERE id = auth.uid();
$$ LANGUAGE sql SECURITY DEFINER;

-- Users table policies
CREATE POLICY "Users can view their own profile" ON users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Admins can view all user profiles" ON users
  FOR SELECT USING (get_user_role() = 'admin');

CREATE POLICY "Users can update their own profile" ON users
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Admins can update any user profile" ON users
  FOR UPDATE USING (get_user_role() = 'admin');

-- Product Types table policies
CREATE POLICY "Anyone can view product types" ON product_types
  FOR SELECT USING (true);

CREATE POLICY "Admins can manage product types" ON product_types
  USING (get_user_role() = 'admin');

-- Products table policies
CREATE POLICY "Anyone can view products" ON products
  FOR SELECT USING (true);

CREATE POLICY "Suppliers can manage their own products" ON products
  USING (auth.uid() = supplier_id);

CREATE POLICY "Admins can manage all products" ON products
  USING (get_user_role() = 'admin');

-- Inventory table policies
CREATE POLICY "Anyone can view inventory" ON inventory
  FOR SELECT USING (true);

CREATE POLICY "Suppliers can manage their own inventory" ON inventory
  USING (auth.uid() = (SELECT supplier_id FROM products WHERE products.id = inventory.product_id));

CREATE POLICY "Admins can manage all inventory" ON inventory
  USING (get_user_role() = 'admin');

-- Bookings table policies
CREATE POLICY "Customers can view their own bookings" ON bookings
  FOR SELECT USING (auth.uid() = customer_id);

CREATE POLICY "Suppliers can view bookings for their products" ON bookings
  FOR SELECT USING (auth.uid() = (SELECT supplier_id FROM products WHERE products.id = (SELECT product_id FROM inventory WHERE inventory.id = bookings.inventory_id)));

CREATE POLICY "Admins can view all bookings" ON bookings
  FOR SELECT USING (get_user_role() = 'admin');

CREATE POLICY "Customers can create bookings" ON bookings
  FOR INSERT WITH CHECK (auth.uid() = customer_id);

CREATE POLICY "Customers can update their own bookings" ON bookings
  FOR UPDATE USING (auth.uid() = customer_id);

-- Maintenance table policies
CREATE POLICY "Suppliers can view and manage maintenance for their products" ON maintenance
  USING (auth.uid() = (SELECT supplier_id FROM products WHERE products.id = (SELECT product_id FROM inventory WHERE inventory.id = maintenance.inventory_id)));

CREATE POLICY "Admins can view and manage all maintenance" ON maintenance
  USING (get_user_role() = 'admin');

-- Reviews table policies
CREATE POLICY "Anyone can view reviews" ON reviews
  FOR SELECT USING (true);

CREATE POLICY "Customers can create reviews for their bookings" ON reviews
  FOR INSERT WITH CHECK (auth.uid() = (SELECT customer_id FROM bookings WHERE bookings.id = reviews.booking_id));

CREATE POLICY "Customers can update their own reviews" ON reviews
  FOR UPDATE USING (auth.uid() = (SELECT customer_id FROM bookings WHERE bookings.id = reviews.booking_id));

-- Transactions table policies
CREATE POLICY "Customers can view their own transactions" ON transactions
  FOR SELECT USING (auth.uid() = (SELECT customer_id FROM bookings WHERE bookings.id = transactions.booking_id));

CREATE POLICY "Suppliers can view transactions for their products" ON transactions
  FOR SELECT USING (auth.uid() = (SELECT supplier_id FROM products WHERE products.id = (SELECT product_id FROM inventory WHERE inventory.id = (SELECT inventory_id FROM bookings WHERE bookings.id = transactions.booking_id))));

CREATE POLICY "Admins can view all transactions" ON transactions
  FOR SELECT USING (get_user_role() = 'admin');

-- Pricing table policies
CREATE POLICY "Anyone can view pricing" ON pricing
  FOR SELECT USING (true);

CREATE POLICY "Suppliers can manage pricing for their products" ON pricing
  USING (auth.uid() = (SELECT supplier_id FROM products WHERE products.id = pricing.product_id));

CREATE POLICY "Admins can manage all pricing" ON pricing
  USING (get_user_role() = 'admin');

-- Discounts table policies
CREATE POLICY "Anyone can view discounts" ON discounts
  FOR SELECT USING (true);

CREATE POLICY "Admins can manage discounts" ON discounts
  USING (get_user_role() = 'admin');

-- Settings table policies
CREATE POLICY "Admins can manage settings" ON settings
  USING (get_user_role() = 'admin');

-- Audit Logs table policies
CREATE POLICY "Admins can view audit logs" ON audit_logs
  FOR SELECT USING (get_user_role() = 'admin');

CREATE POLICY "System can insert audit logs" ON audit_logs
  FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);