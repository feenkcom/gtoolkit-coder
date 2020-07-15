Extension { #name : #RBRemoveInstanceVariableRefactoring }

{ #category : #'*GToolkit-Coder' }
RBRemoveInstanceVariableRefactoring >> gtDescription [
	<return: #String or: #BlRopedText>
	
	^ ('Remove' asRopedText glamorousRoundedBackground)
		append: ' instance variable ' asRopedText;
		append: variableName asRopedText glamorousRoundedBackground;
		append: ' from ' asRopedText;
		append: class printString asRopedText
]

{ #category : #'*GToolkit-Coder' }
RBRemoveInstanceVariableRefactoring >> gtPreconditions [
	| references |

	references := RBCondition hierarchyOf: class referencesInstanceVariable: variableName.
	references errorMacro: ( '<1s> is referenced.' expandMacrosWith: variableName).

	^ ( RBCondition definesInstanceVariable: variableName asString in: class ) & references not
]
