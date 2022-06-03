import {Response} from 'express';

class ResponseAPI {
  private res: Response;
  private data: any;
  private message: string;

  get status(): boolean {
    return this.data ? true : false;
  }

  constructor(res: Response, {data, message}: {data?: any; message?: string}) {
    this.res = res;
    if (data) this.data = data;
    if (message) this.message = message;
  }

  toJson() {
    return {
      status: this.status,
      data: this.data,
      message: this.message,
    };
  }
  excute(code: number) {
    this.res.status(code).json(this.toJson());
  }
}

export default ResponseAPI;
