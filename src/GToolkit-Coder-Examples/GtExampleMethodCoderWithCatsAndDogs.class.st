Class {
	#name : #GtExampleMethodCoderWithCatsAndDogs,
	#superclass : #GtMethodCoder,
	#category : #'GToolkit-Coder-Examples-Dummies'
}

{ #category : #'as yet unclassified' }
GtExampleMethodCoderWithCatsAndDogs >> catsAddOnFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 1>
	(self compiledMethod notNil
		and: [ anAST notNil
				and: [ 
					anAST methodNode
						ifNotNil: [ :node | 
							node pragmas
								anySatisfy: [ :each | each isParseError not and: [ each selector = #cats ] ] ]
						ifNil: [ false ] ] ])
		ifFalse: [ ^ self ].
	coderAddOns
		addContextAction: 'Feed cats' translated
		icon: BrGlamorousVectorIcons playinspect
		action: [ :aCoderUIModel :anEvent | self inform: 'Feed cats' ].
]
