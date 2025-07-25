Extension { #name : #RBCondition }

{ #category : #'*GToolkit-Coder' }
RBCondition class >> includesPoolDictionary: aString in: aClass [
	^ self new
		block: [ aClass sharedPoolNames includes: aString asSymbol ]
		errorString: aString , ' is <1?:not >included in ' , aClass name
]

{ #category : #'*GToolkit-Coder' }
RBCondition class >> isPoolDictionary: aString in: aRBSmalltalk [
	^ self new
		block: [ (aRBSmalltalk includesGlobal: aString asSymbol)
				and: [ Smalltalk globals
						at: aString asSymbol
						ifPresent: [ :dict | dict isKindOf: SharedPool class ]
						ifAbsent: [ false ] ] ]
		errorString: aString , ' is <1?:not >a pool dictionary'
]
