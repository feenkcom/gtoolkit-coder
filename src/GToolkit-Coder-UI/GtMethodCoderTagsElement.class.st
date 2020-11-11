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

{ #category : #private }
GtMethodCoderTagsElement >> behaviorProtocols [
	| allSubAndSuperclassProtocols excludedClasses |
	
	allSubAndSuperclassProtocols := Set new.
	excludedClasses := Set withAll: { ProtoObject . Object }.
	
	self methodCoderUIModel coder behavior withAllSubAndSuperclassesDo: [ :eachBehavior |
		(excludedClasses includes: eachBehavior)
			ifFalse: [ allSubAndSuperclassProtocols addAll: eachBehavior protocols ] ].

	^ allSubAndSuperclassProtocols asArray sorted
]

{ #category : #initialization }
GtMethodCoderTagsElement >> buildTags [	
	protocolTag := self newProtocolTag.

	^ { protocolTag }
]

{ #category : #initialization }
GtMethodCoderTagsElement >> initialize [
	super initialize.
	
	isEditable := false.
	
	self 
		layout: (BlLinearLayout horizontal cellSpacing: 4);
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
	
	aMethodCoderUIModel coder weak
		when: GtCoderSourceTextModified
		send: #onCoderSourceTextModified:
		to: self.

	self updateProtocolButton
]

{ #category : #'instance creation' }
GtMethodCoderTagsElement >> newEditableProtocolTag [
	^ BrButton new
		beTiny;
		look: BrGlamorousButtonWithLabelLook + (BrGlamorousWithDropdownLook
			handle: [
				| editor |

				editor := BrEditableLabel new
					text: (self protocolStringFor: self methodCoderUIModel);
					constraintsDo: [ :c | c minWidth: 100 ];
					look:
						(BrGlamorousEditableLabelLook new
							glamorousCodeFont;
							defaultForeground: Color black;
							fontSize: 13);
					padding: (BlInsets all: 4);
					switchToEditor;
					requestFocus;
					when: BrEditorAcceptWish
						do: [ :aWish | 
							aWish currentTarget fireEvent: (BrDropdownHideWish new).
							self methodCoderUIModel coder renameProtocol: aWish text asString.
							protocolTag label: (self protocolStringFor: self methodCoderUIModel) ];
					when: BrEditorCancelWish
						do: [ :aWish | aWish currentTarget fireEvent: (BrDropdownHideWish new) ];
					whenKey: BlKeyCombination primaryC
						labelDo: [ :aShortcutEvent :aShortcut | 
							Clipboard clipboardText: aShortcutEvent currentTarget text asString ].
				(GtCompletionController
					on: editor
					strategy: GtMethodProtocolCompletionStrategy new) install.
				editor ]
			content: [
				BrSimpleList new
					vFitContentLimited;
					hExact: 250;
					itemStencil: [
						BrButton new
							beSmall;
							look: BrGlamorousButtonRectangularLook + BrGlamorousButtonLabelLook;
							action: [ :aButton :aButtonModel |
								aButton fireEvent: (BrDropdownHideWish new).
								self methodCoderUIModel coder renameProtocol: aButtonModel model asString.
								protocolTag label: (self protocolStringFor: self methodCoderUIModel) ] ];
					itemDataBinder: [ :eachButton :eachProtocol |
						eachButton viewModel model: eachProtocol.
						eachButton label: eachProtocol ];
					items: self behaviorProtocols ])
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

{ #category : #'event handling' }
GtMethodCoderTagsElement >> onCoderSourceTextModified: anAnnouncement [
	
	isEditable
		ifTrue: [ protocolTag disabled: anAnnouncement coder isModified ]
]

{ #category : #private }
GtMethodCoderTagsElement >> protocolStringFor: aMethodCoderUIModel [
	<return: #String>

	^ aMethodCoderUIModel coder protocol
]

{ #category : #private }
GtMethodCoderTagsElement >> updateProtocolButton [
	isEditable
		ifTrue: [ protocolTag label: (self protocolStringFor: self methodCoderUIModel) ]
		ifFalse: [ protocolTag text: (self protocolStringFor: self methodCoderUIModel) ]
]
