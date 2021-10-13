Extension { #name : #Slot }

{ #category : #'*GToolkit-Coder' }
Slot class >> gtIsValidName: aSymbol [
	<return: #Boolean>

	aSymbol
		ifNil: [ ^ false ].

	aSymbol
		ifEmpty: [ ^ false ].

	^ [
		self checkValidName: aSymbol.
		true ]
	on: Error do: [ :e | false ]
]
