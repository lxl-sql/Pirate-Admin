import {ApiExtraModels, ApiOkResponse, getSchemaPath} from "@nestjs/swagger";
import {applyDecorators, Type} from "@nestjs/common";
import {ResponseType} from "@/enums/response-type.enum";
import {NotPaginationVo, PaginationVo, ResponseVo} from "@/vos/response.vo";

export function ApiVoResponse<TModal = any>(modal: Type<TModal>, responseType = ResponseType.DEFAULT) {
  const dataSchema = {
    1: {
      $ref: getSchemaPath(modal)
    },
    2: {
      $ref: getSchemaPath(PaginationVo<TModal>),
      properties: {
        records: {
          type: 'array',
          items: {$ref: getSchemaPath(modal)},
        },
      },
    },
    3: {
      $ref: getSchemaPath(NotPaginationVo<TModal>),
      properties: {
        records: {
          type: 'array',
          items: {$ref: getSchemaPath(modal)},
        },
      },
    }
  }

  return applyDecorators(
    ApiExtraModels(ResponseVo<TModal>, PaginationVo<TModal>, modal),
    ApiOkResponse({
      schema: {
        allOf: [
          {$ref: getSchemaPath(ResponseVo<TModal>)},
          {
            properties: {
              data: dataSchema[responseType],
            },
          },
        ],
      },
    }),
  );
}
