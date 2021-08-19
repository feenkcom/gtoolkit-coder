Extension { #name : 'RBMethod' }

{ #category : '*GToolkit-Coder' }
RBMethod >> containsSubstring: aString [
	^ (source
		ifNil: [ (class realClass sourceCodeAt: selector) asString ])
		includesSubstring: aString
]
