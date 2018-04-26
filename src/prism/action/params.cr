require "../params"

module Prism
  struct Action
    module Params
      include Prism::Params

      macro params(&block)
        Prism::Params.params do
          {{yield}}
        end

        @params = uninitialized ParamsTuple
        protected getter params

        before do
          begin
            @params = self.class.parse_params(context, self.class.max_body_size)
          rescue ex : InvalidParamTypeError | ParamNotFoundError | InvalidParamError
            context.response.status_code = 422
            context.response.print(ex.message)
          end
        end
      end
    end
  end
end
