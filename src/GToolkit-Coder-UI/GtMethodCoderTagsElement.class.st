"
I display various tags in the method coder element such as protocol or instance/class side
"
Class {
	#name : #GtMethodCoderTagsElement,
	#superclass : #BlElement,
	#instVars : [
		'protocolTag',
		'isEditable',
		'methodCoderUIModel'
	],
	#category : #'GToolkit-Coder-UI-Coder - Method'
}

{ #category : #initialization }
GtMethodCoderTagsElement >> buildTags [	
	protocolTag := self newProtocolTag.

	^ { protocolTag }
]

{ #category : #accessing }
GtMethodCoderTagsElement >> coder [
	<return: #GtMethodCoderUIModel>
	
	self 
		deprecated: 'Use #methodCoderUIModel instead.'
		transformWith: '`@receiver coder' -> '`@receiver methodCoderUIModel'.
		
	^ self methodCoderUIModel
]

{ #category : #accessing }
GtMethodCoderTagsElement >> coder: aMethodCoderUIModel [
	self 
		deprecated: 'Use #methodCoderUIModel: instead.'
		transformWith: '`@receiver coder: `@arg' -> '`@receiver methodCoderUIModel: `@arg'.
		
	self methodCoderUIModel: aMethodCoderUIModel
]

{ #category : #initialization }
GtMethodCoderTagsElement >> initialize [
	super initialize.
	
	isEditable := false.
	
	self 
		layout: (BlLinearLayout horizontal cellSpacing: 4);
		geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
		background: Color white;
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent ]
]

{ #category : #initialization }
GtMethodCoderTagsElement >> initializeTags [
	self removeChildren.	
	self addChildren: self buildTags
]

{ #category : #accessing }
GtMethodCoderTagsElement >> methodCoderUIModel [
	^ methodCoderUIModel
]

{ #category : #accessing }
GtMethodCoderTagsElement >> methodCoderUIModel: aMethodCoderUIModel [
	self
		assert: [ aMethodCoderUIModel isKindOf: GtMethodCoderUIModel ]
		description: [ 'Must be method coder''s UI Model' ].

	(methodCoderUIModel isNil or: [ isEditable ~= aMethodCoderUIModel expanded ])
		ifTrue: [
			isEditable := aMethodCoderUIModel expanded.
			self initializeTags ].

	methodCoderUIModel := aMethodCoderUIModel.

	protocolTag text: (self protocolStringFor: aMethodCoderUIModel)
]

{ #category : #'instance creation' }
GtMethodCoderTagsElement >> newEditableProtocolTag [
	| editor |

	editor := BrEditableLabel new
		look:
			(BrGlamorousEditableLabelLook new
				glamorousCodeFont;
				defaultForeground: Color black;
				fontSize: 10);
		padding: (BlInsets all: 2);
		when: BrEditorAcceptWish
			do: [ :aWish | 
				self methodCoderUIModel
					ifNotNil: [ :aMethodCoderUIModel | aMethodCoderUIModel coder renameProtocol: aWish text asString ] ];
		whenKey: BlKeyCombination primaryC
			labelDo: [ :anEvent :aShortcut :aTextEditor :aCoderTagsElement | 
				Clipboard clipboardText: aTextEditor text asString ]
			with: self.

	(GtCompletionController
		on: editor
		strategy: GtMethodProtocolCompletionStrategy new) install.
		
	^ editor
]

{ #category : #'instance creation' }
GtMethodCoderTagsElement >> newProtocolTag [
	^ isEditable
		ifTrue: [ self newEditableProtocolTag ]
		ifFalse: [ self newReadonlyProtocolTag ]
]

{ #category : #'instance creation' }
GtMethodCoderTagsElement >> newReadonlyProtocolTag [
	^ self newTag
]

{ #category : #'instance creation' }
GtMethodCoderTagsElement >> newTag [
	<return: #BlElement>

	^ BrLabel new
		look: (BrGlamorousLabelLook new
			glamorousCodeFont;
			foreground: Color black;
			fontSize: 10);
		text: '';
		padding: (BlInsets all: 2)
]

{ #category : #private }
GtMethodCoderTagsElement >> protocolStringFor: aMethodCoderUIModel [
	<return: #String>
	^ aMethodCoderUIModel coder protocol
]
