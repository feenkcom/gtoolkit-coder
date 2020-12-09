"
I display various tags in the method coder element such as protocol or instance/class side
"
Class {
	#name : #GtMethodCoderTagsElement,
	#superclass : #BlElement,
	#instVars : [
		'protocolTag',
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
	
	self 
		layout: (BlLinearLayout horizontal cellSpacing: 4);
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent ].
		
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

	methodCoderUIModel == aMethodCoderUIModel
		ifTrue: [ ^ self ].

	"do not forget to unsubscribe from the previous coder"
	self unsubscribeFromCoder.

	methodCoderUIModel := aMethodCoderUIModel.
	
	aMethodCoderUIModel coder weak
		when: GtCoderSourceCodeChanged
		send: #onCoderSourceTextModified:
		to: self.

	self updateProtocolButton
]

{ #category : #'private - instance creation' }
GtMethodCoderTagsElement >> newProtocolEditor [
	| anEditor |

	anEditor := BrEditableLabel new
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
				self updateProtocolButton ];
		when: BrEditorCancelWish
			do: [ :aWish | aWish currentTarget fireEvent: (BrDropdownHideWish new) ];
		whenKey: BlKeyCombination primaryC
			labelDo: [ :aShortcutEvent :aShortcut | 
				Clipboard clipboardText: aShortcutEvent currentTarget text asString ].
	(GtCompletionController
		on: anEditor
		strategy: GtMethodProtocolCompletionStrategy new) install.

	^ anEditor
]

{ #category : #'private - instance creation' }
GtMethodCoderTagsElement >> newProtocolPickerList [
	^ BrSimpleList new
		vFitContentLimited;
		hExact: 250;
		itemStencil: [
			BrButton new
				beSmallSize;
				look: BrGlamorousButtonRectangularLook + BrGlamorousButtonLabelLook;
				action: [ :aButton :aButtonModel |
					aButton fireEvent: (BrDropdownHideWish new).
					self methodCoderUIModel coder renameProtocol: aButtonModel model asString.
					self updateProtocolButton ] ];
		itemDataBinder: [ :eachButton :eachProtocol |
			eachButton viewModel model: eachProtocol.
			eachButton label: eachProtocol ];
		items: self behaviorProtocols
]

{ #category : #'private - instance creation' }
GtMethodCoderTagsElement >> newProtocolTag [
	^ BrButton new
		beTinySize;
		look: BrGlamorousButtonWithLabelLook + (BrGlamorousWithDropdownLook
			handle: [ self newProtocolEditor ]
			content: [ self newProtocolPickerList ])
]

{ #category : #'event handling' }
GtMethodCoderTagsElement >> onCoderSourceTextModified: anAnnouncement [
	protocolTag disabled: anAnnouncement coder isModified
]

{ #category : #private }
GtMethodCoderTagsElement >> protocolStringFor: aMethodCoderUIModel [
	<return: #String>

	^ aMethodCoderUIModel coder protocol
]

{ #category : #private }
GtMethodCoderTagsElement >> unsubscribeFromCoder [
	methodCoderUIModel
		ifNil: [ ^ self ].

	methodCoderUIModel coder unsubscribe: self
]

{ #category : #private }
GtMethodCoderTagsElement >> updateProtocolButton [
	protocolTag label: (self protocolStringFor: self methodCoderUIModel)
]
