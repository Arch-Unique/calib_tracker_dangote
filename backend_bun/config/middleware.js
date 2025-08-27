export const errorHandler = async (err, c) => {
  console.error('Error:', err);
  
  return c.json({
    success: false,
    error: 'Internal server error',
    message: process.env.NODE_ENV === 'development' ? err.message : 'Something went wrong'
  }, 500);
};


// export const logger = async (c, next) => {
//   const start = Date.now();
//   await next();
//   const end = Date.now();
//   console.log(`${c.req.method} ${c.req.url} - ${c.res.status} - ${end - start}ms`);
// };