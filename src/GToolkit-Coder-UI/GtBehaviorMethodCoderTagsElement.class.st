Class {
	#name : #GtBehaviorMethodCoderTagsElement,
	#superclass : #GtMethodCoderTagsElement,
	#instVars : [
		'classTag'
	],
	#category : #'GToolkit-Coder-UI-Coder - Method'
}

{ #category : #initialization }
GtBehaviorMethodCoderTagsElement >> buildTags [
	^ super buildTags, { classTag := self newClassTag }
]

{ #category : #private }
GtBehaviorMethodCoderTagsElement >> classTagStringFor: aMethodCoderUIModel [
	<return: #String>
	^ aMethodCoderUIModel coder behavior isMeta
		ifTrue: [ 'class' ]
		ifFalse: [ 'instance' ]
]

{ #category : #accessing }
GtBehaviorMethodCoderTagsElement >> methodCoderUIModel: aMethodCoderUIModel [
	super methodCoderUIModel: aMethodCoderUIModel.

	classTag text: (self classTagStringFor: aMethodCoderUIModel)
]

{ #category : #'instance creation' }
GtBehaviorMethodCoderTagsElement >> newClassTag [
	^ isEditable
		ifTrue: [ self newEditableClassTag ]
		ifFalse: [ self newReadonlyClassTag ]
]

{ #category : #'instance creation' }
GtBehaviorMethodCoderTagsElement >> newEditableClassTag [
	| editor completion strategy |
	editor := BrEditableLabel new
		look:
			(BrGlamorousEditableLabelLook new
				glamorousCodeFont;
				defaultForeground: Color black;
				fontSize: 10);
		padding: (BlInsets all: 2);
		margin: (BlInsets all: 0).
	editor
		when: BrEditorModeWish
			do: [ :wish | 
			(wish mode isEditable
				and: [ self methodCoderUIModel coder canMoveMethodToInstanceOrClass not ])
				ifTrue: [ editor beReadOnlyWithoutSelection.
					wish mode: BrTextEditorReadonlyWithoutSelectionMode new ] ];
		when: BrEditorAcceptWish
			do: [ :wish | 
			(self methodCoderUIModel coder behavior isMeta
				ifTrue: [ wish text asString asLowercase = 'instance' ]
				ifFalse: [ wish text asString asLowercase = 'class' ])
				ifTrue: [ self methodCoderUIModel coder moveMethodToInstanceOrClass ].
			editor text: (self classTagStringFor: self methodCoderUIModel).
			wish consumed: true ];
		whenKey: BlKeyCombination primaryC
			labelDo:
				[ :anEvent :aShortcut | Clipboard clipboardText: anEvent currentTarget text asString ].
	strategy := GtStringsCompletionStrategy new.
	(GtCompletionController on: editor strategy: strategy) install.
	completion := GtPrefixTree withAll: #('instance' 'class').
	strategy completions: completion.
	^ editor
]

{ #category : #'instance creation' }
GtBehaviorMethodCoderTagsElement >> newReadonlyClassTag [
	<return: #BlElement>

	^ self newTag
]
