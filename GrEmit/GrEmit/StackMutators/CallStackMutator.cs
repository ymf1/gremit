using System;
using System.Collections.Generic;

using GrEmit.InstructionParameters;

namespace GrEmit.StackMutators
{
    internal class CallStackMutator : StackMutator
    {
        public override void Mutate(GroboIL il, ILInstructionParameter parameter, ref Stack<Type> stack)
        {
            var method = ((MethodILInstructionParameter)parameter).Method;
            var parameterTypes = Formatter.GetParameterTypes(method);
            for(int i = parameterTypes.Length - 1; i >= 0; --i)
            {
                CheckNotEmpty(il, stack);
                CheckCanBeAssigned(il, parameterTypes[i], stack.Pop());
            }
            if(!method.IsStatic)
            {
                CheckNotEmpty(il, stack);
                CheckNotStruct(il, stack.Pop());
            }
            if(method.ReturnType != typeof(void))
                stack.Push(method.ReturnType);
        }
    }
}