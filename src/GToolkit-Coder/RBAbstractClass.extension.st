Extension { #name : #RBAbstractClass }

{ #category : #'*GToolkit-Coder' }
RBAbstractClass >> gtInstanceVariableNames [
	| instVarsToRemove |
	
	instVarsToRemove := self isDefined
		ifTrue: [ | localInstVars instVars |
			localInstVars := self realClass localSlots collect: #name.
			instVars := self realClass instVarNames.
			
			instVars difference: localInstVars ]
		ifFalse: [ #() ].

	self instanceVariableNames: (self instanceVariableNames copyWithoutAll: instVarsToRemove).

	^ self instanceVariableNames
]
