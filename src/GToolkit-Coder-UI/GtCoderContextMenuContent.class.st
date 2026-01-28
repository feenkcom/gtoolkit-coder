"
I represent a Coder context menu. 
#Examples
The following example shows a case during which a context menu height does not fit and a scrollbar is displayed: {{gtExample:GtPharoCoderByScripterExamples>>#displayPharoMethodContextMenuExtentIn800x345Space | previewExpanded=true | codeExpanded=false | previewHeight=500}} 
 
"
Class {
	#name : #GtCoderContextMenuContent,
	#superclass : #GtAbstractCoderContextMenuContent,
	#instVars : [
		'editorElement'
	],
	#category : #'GToolkit-Coder-UI-Basic'
}

{ #category : #'api - accessing' }
GtCoderContextMenuContent >> editorElement [
	<return: #BrEditorElement>
	^ editorElement
]

{ #category : #'api - accessing' }
GtCoderContextMenuContent >> editorElement: anEditorElement [
	self 
		assert: [ anEditorElement isNotNil ] 
		description: [ 'Editor element must be non-nil' ].
	editorElement := anEditorElement
]

{ #category : #initialization }
GtCoderContextMenuContent >> menuItemStencil [
	^ [ :eachGtCoderContextMenuAction :aRowIndex | 
	| element labelText |
	element := BrHorizontalPane new
			id: (GtCoderContextMenuItemId indexed: aRowIndex);
			hMatchParent;
			vFitContent;
			alignCenter;
			addAptitude: self selectionAptitude;
			padding: self itemPadding.
	
	labelText := eachGtCoderContextMenuAction title asRopedText .
	eachGtCoderContextMenuAction isEnabled 
		ifFalse: [ labelText := labelText 
			foreground: BrGlamorousColors disabledButtonTextColor  ].
	element addChild: (self itemLabelFor: labelText).
	
	eachGtCoderContextMenuAction isEnabled 
		ifTrue: [
			element 
				when: BlClickEvent
				do: [ :anEvent | 
					anEvent consumed: true.
					eachGtCoderContextMenuAction action
						cull: self textualCoderViewModel
						cull: self editorElement
						cull: anEvent.
					self fireEvent: BrDropdownHideWish new.
					self fireEvent: BrContextMenuHideWish new ] ].
	((eachGtCoderContextMenuAction shortcutKey respondsTo: #isEmpty)
		and: [ eachGtCoderContextMenuAction shortcutKey isEmpty not ])
		ifTrue: [ element
				addChild: (BrHorizontalPane new
						fitContent;
						geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
						border: (BlBorder paint: Color gray width: 1);
						padding: (BlInsets all: 1);
						margin: (BlInsets left: 10);
						addChild: (BrLabel new
								aptitude: BrGlamorousLabelAptitude;
								text: (eachGtCoderContextMenuAction shortcutKey asRopedText
										fontName: 'Source Code Pro';
										foreground: Color gray;
										fontSize: 10);
								hFitContent;
								yourself);
						yourself) ].
	eachGtCoderContextMenuAction hoverAction
		ifNotNil: [ :hover | 
			element
				when: BlMouseEnterEvent
				do: [ :anEvent | 
					hover cull: self textualCoderViewModel cull: anEvent ] ].
	eachGtCoderContextMenuAction leaveAction
		ifNotNil: [ :leave | 
			element
				when: BlMouseLeaveEvent
				do: [ :anEvent | 
					leave cull: self textualCoderViewModel cull: anEvent ] ].
	eachGtCoderContextMenuAction name
		ifNotNil: [ :anActionName | element containerName: anActionName ].
		
	eachGtCoderContextMenuAction isEnabled ifTrue: [
		element
			when: BlMouseEnterEvent
				do: [ :anEvent | self selectOne: aRowIndex ];
			when: BlMouseLeaveEvent
				do: [ :anEvent | self deselectOne: aRowIndex ] ].
		
	element ]
]

{ #category : #'api - accessing' }
GtCoderContextMenuContent >> textualCoderViewModel [
	"We add a context menu to the CoderElement, not to the editor element"

	self flag: #TODO.
	
	"There is a hack in:
	- `GtSmaCCGrammarCoder>>#addMenuItemsElement` adds itself as an editor element, and
	- implements `GtSmaCCGrammarCoder>>#textualCoderViewModel`.
	- It is called from `SmaCCParser class>>#gtGrammarFor:context:`.
	
	It is not covered by any example.
	
	How to reproduce: 
	- browse LineParser class, 
	- in the `Grammar` tab click on the plus button,
	- select Production from the dropdown menu.
	
	Note: it was causing DNU because the coder model does not understands parent.
	See: https://github.com/feenkcom/gtoolkit/issues/4924"

	^ (editorElement respondsTo: #textualCoderViewModel)
		ifTrue: [ editorElement textualCoderViewModel ]
		ifFalse: [ editorElement parent textualCoderViewModel ]
]
