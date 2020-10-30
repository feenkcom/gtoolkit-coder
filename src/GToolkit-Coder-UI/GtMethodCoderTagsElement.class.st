"
I display various tags in the method coder element such as protocol or instance/class side
"
Class {
	#name : #GtMethodCoderTagsElement,
	#superclass : #BlElement,
	#instVars : [
		'protocolTag',
		'isEditable',
		'coder'
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
	^ coder
]

{ #category : #accessing }
GtMethodCoderTagsElement >> coder: aMethodCoder [
	(coder isNil or: [ isEditable ~= aMethodCoder expanded ])
		ifTrue: [
			isEditable := aMethodCoder expanded.
			self initializeTags ].

	coder := aMethodCoder.

	protocolTag text: (self protocolStringFor: aMethodCoder)
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
				self coder ifNotNil: [ :aCoder | 
					aCoder renameProtocol: aWish text asString ] ];
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
GtMethodCoderTagsElement >> protocolStringFor: aMethodCoder [
	<return: #String>

	^ aMethodCoder category
]
