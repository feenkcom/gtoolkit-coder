Extension { #name : #RBRemoveInstanceVariableRefactoring }

{ #category : #'*GToolkit-Coder' }
RBRemoveInstanceVariableRefactoring >> gtPreconditions [
	| references |

	references := RBCondition hierarchyOf: class referencesInstanceVariable: variableName.
	references errorMacro: ( '<1s> is referenced.' expandMacrosWith: variableName).

	^ ( RBCondition definesInstanceVariable: variableName asString in: class ) & references not
]
