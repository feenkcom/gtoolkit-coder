Class {
	#name : #GtCoderExpandableBaselineStyler,
	#superclass : #GtGenericPharoStyler,
	#category : #'GToolkit-Coder-Pharo-AddOns-Expandable baseline'
}

{ #category : #private }
GtCoderExpandableBaselineStyler >> isNonEmptyLiteralStringNode: nameNode [
	^ nameNode isLiteral
		and: [ nameNode literalValue isString
			and: [ nameNode literalValue notEmpty ] ]
]

{ #category : #private }
GtCoderExpandableBaselineStyler >> styleBaselineMessage: aMessageNode [
	| aBaselineNameNode anExpanderAttribute |

	aBaselineNameNode := aMessageNode arguments first.

	(self isNonEmptyLiteralStringNode: aBaselineNameNode)
		ifFalse: [ ^ self ].

	self
		attribute: (GtCompletionStrategyAttribute new strategy: GtBaselineOfClassCompletionStrategy new)
		from: aBaselineNameNode value startPosition
		to: aBaselineNameNode value stopPosition.

	(Smalltalk globals
		includesKey: ('BaselineOf' , aBaselineNameNode literalValue asString) asSymbol)
		ifFalse: [ ^ self ].

	anExpanderAttribute := (BrGlamorousTrangleExpanderTextAttribute new
		attributesCreatingBlock: [
			BrTextAdornmentDynamicAttribute new
				beAppend;
				stencil: [ | aBaselineMethod aBaselineMethodCoder |
					aBaselineMethod := (self class environment
						at: ('BaselineOf' , aBaselineNameNode literalValue asString) asSymbol) >> #baseline:.
					aBaselineMethodCoder := GtPharoMethodCoder forMethod: aBaselineMethod.
					aBaselineMethodCoder subscribeToSystem.
					(aBaselineMethodCoder asCoderViewModel expanded: true) asElement
						border: (BlBorder paint: Color veryLightGray width: 1);
						margin: (BlInsets top: 3 right: 10 bottom: 10 left: 10) ] ]).

	self
		attribute: anExpanderAttribute
		from: aBaselineNameNode value stopPosition
		to: aBaselineNameNode value stopPosition.
]

{ #category : #private }
GtCoderExpandableBaselineStyler >> stylePackageMessage: aMessageNode [
	| aPackageNameNode |
	
	aPackageNameNode := aMessageNode arguments first.

	(self isNonEmptyLiteralStringNode: aPackageNameNode)
		ifFalse: [ ^ self ].

	self
		attribute: (GtCompletionStrategyAttribute new strategy: GtBaselinePackageCompletionStrategy new)
		from: aPackageNameNode value startPosition
		to: aPackageNameNode value stopPosition
]

{ #category : #visiting }
GtCoderExpandableBaselineStyler >> visitMessage: aMessageNode [
	super visitMessage: aMessageNode.
	
	(#(baseline: #baseline:with:) includes: aMessageNode selector)
		ifTrue: [ self styleBaselineMessage: aMessageNode ].

	(#(package: #package:with:) includes: aMessageNode selector)
		ifTrue: [ self stylePackageMessage: aMessageNode ]
]
