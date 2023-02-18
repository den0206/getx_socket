import {HydratedDocument, Model, PopulateOptions} from 'mongoose';

export async function usePagenation<T>({
  model,
  limit,
  cursor,
  select = [],
  pop,
  exclued,
  opt,
  specific,
  sort = {_id: -1},
  blockUsers,
}: {
  model: Model<T>;
  limit: number;
  cursor?: string;
  select?: string[];
  pop?: string | string[]; // for multiple
  exclued?: string | string[];
  opt?: PopulateOptions | PopulateOptions[];
  specific?: {};
  sort?: {};
  blockUsers?: string[];
}) {
  let query = {};

  if (cursor) {
    query = {
      _id: {
        $lt: Base64.decodeToBase64(cursor),
        $nin: blockUsers,
      },
    };
  } else if (blockUsers) {
    query = {
      _id: {
        $nin: blockUsers,
      },
    };
  }

  if (specific) {
    query = {...query, ...specific};
  }

  let array: HydratedDocument<T, {}, {}>[];
  if (pop) {
    array = await model
      .find(query)
      .select(select)
      .sort(sort)
      .limit(limit + 1)
      .populate(pop, exclued);
  } else if (opt) {
    array = await model
      .find(query)
      .select(select)
      .sort(sort)
      .limit(limit + 1)
      .populate(opt);
  } else {
    array = await model
      .find(query)
      .select(select)
      .sort(sort)
      .limit(limit + 1);
  }

  const hasNextPage = array.length > limit;
  array = hasNextPage ? array.slice(0, -1) : array;
  const nextPageCursor = hasNextPage
    ? Base64.encodeBase64(array[array.length - 1].id)
    : null;

  const data = {
    pageFeeds: array,
    pageInfo: {nextPageCursor, hasNextPage},
  };

  return data;
}

class Base64 {
  static encodeBase64(data: any) {
    return Buffer.from(data).toString('base64');
  }

  static decodeToBase64(data: any) {
    return Buffer.from(data, 'base64').toString('ascii');
  }
}
