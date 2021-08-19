Class {
	#name : 'GtWatchExpression',
	#superclass : 'Object',
	#instVars : [
		'expression'
	],
	#classVars : [
		'MethodExpressions'
	],
	#category : 'GToolkit-Coder'
}

{ #category : 'accessing' }
GtWatchExpression class >> addExpression: aString for: aCompiledMethod [
	^ ((self methodExpressions at: aCompiledMethod methodClass ifAbsentPut: [ WeakKeyDictionary new ])
		at: aCompiledMethod selector
		ifAbsentPut: [ Set new ]) add: (self new expression: aString)
]

{ #category : 'accessing' }
GtWatchExpression class >> expressionsFor: aCompiledMethod [
	^ (self methodExpressions at: aCompiledMethod methodClass ifAbsent: [ ^ #() ]) at: aCompiledMethod selector ifAbsent: [ #() ]
]

{ #category : 'accessing' }
GtWatchExpression class >> methodExpressions [
	^ MethodExpressions ifNil: [ MethodExpressions := WeakKeyDictionary new ]
]

{ #category : 'accessing' }
GtWatchExpression class >> removeExpression: aWatchExpression for: aCompiledMethod [
	((self methodExpressions at: aCompiledMethod methodClass ifAbsent: [ ^ self ]) at: aCompiledMethod selector ifAbsent: [ ^ self ])
		remove: aWatchExpression
		ifAbsent: [  ]
]

{ #category : 'accessing' }
GtWatchExpression class >> reset [
	MethodExpressions := nil
]

{ #category : 'comparing' }
GtWatchExpression >> = anObject [
	^ self class = anObject class and: [ self expression = anObject expression ]
]

{ #category : 'accessing' }
GtWatchExpression >> expression [
	^ expression
]

{ #category : 'accessing' }
GtWatchExpression >> expression: aString [
	expression := aString
]

{ #category : 'comparing' }
GtWatchExpression >> hash [
	^ expression hash
]

{ #category : 'evaluating' }
GtWatchExpression >> valueIn: aContext [
	^ [ aContext receiver class compiler
		source: expression;
		receiver: aContext receiver;
		context: aContext;
		failBlock: [ ^ 'Failed evaluating code' ];
		evaluate ]
		on: Error
		do: [ :ex | 
			ex freeze.
			ex return: ex ]
]
