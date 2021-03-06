// NOTE: This module just tries to map strings in the
// overall error message to corresponding error codes.
// It should be considered a last resort. Individual apps should
// handle their own errors using the status code extension in GraphQL queries.
// It's existence is only really a temporary compatibility layer between our error responses
// and the doomed artsy-error-middleware.

import { any } from 'underscore';

const contains = (message, targetStrings = []) =>
  any(targetStrings.map(targetString =>
    message.toLowerCase().indexOf(targetString.toLowerCase()) >= 0)
  );

const ERROR_404 = new Error('Not found');
ERROR_404.status = 404;

const ERROR_401 = new Error('Access denied');
ERROR_401.status = 401;

export default (err, req, res, next) => {
  let error;

  if (contains(err.message, [
    'not found', // Old-style errors
    "can't find", // New-style errors
  ])) error = ERROR_404;

  if (contains(err.message, [
    'unauthorized', // Old-style errors
    'access denied', // Old-style errors
    'unable to', // New-style errors
  ])) error = ERROR_401;

  return next(error || err);
};
