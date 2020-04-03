defmodule Der do
    @type literal() :: {:const, number()} 
                | {:const, atom()} 
                | {:var, atom()}

    @type expr() :: {:add, expr(), expr()} 
            | {:mul, expr(), expr()} 
            | literal()

    
end