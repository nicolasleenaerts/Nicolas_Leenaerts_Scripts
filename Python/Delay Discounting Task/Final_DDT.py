# This imports the relevant modules for the experiment

from psychopy import visual, core, data, event, gui
from psychopy.hardware.emulator import launchScan
import random

# This codes the settings for the launchscan code
MRI_Settings = {
    'TR':2,
    'volumes' : 2,
    'sync' : 5,
    'skip' : 0,
    'sound' : False
}

# This sets a clock for the ISI
clock_ISI = core.Clock()

# This sets a clock for  for the trial
clock_Trial = core.Clock()

# This codes for the storage of data
exp = data.ExperimentHandler(name='DDT',
                version='1.0',
                extraInfo={},
                runtimeInfo=None,
                originPath=None,
                savePickle=True,
                saveWideText=True,
                dataFileName='DDT')

# This imports the conditions from the Excell file
trialList = data.importConditions('beeld_geld.xlsx')

# This defines our trial and adds it to the data storage
trials = data.TrialHandler(trialList, 1, method = 'random')
exp.addLoop(trials)

#This codes the Graphics User Interface (GUI)
infoDlg = gui.DlgFromDict(MRI_Settings, title='fMRI parameters', order=['TR', 'volumes'])

# This codes for GUI for the MAD
MAD = []
infoDlg2 = gui.DlgFromDict(MAD, title='Maximally Accepted Delay')


#This gives the launchscan code a clock ans a small opening window
globalClock = core.Clock()
win_launch = visual.Window(fullscr = True, color = [-1,-1,-1])

# This codes for the launchScan attribute
vol = launchScan(
    win = win_launch,
    settings = MRI_Settings,
    globalClock = globalClock
)

#This codes for the screen
win_MRI_task = visual.Window(
    size= [2048,1152],
    units = 'pix',
    color = [-1,-1,-1],
    fullscr = True
    )

# This section defines all the stimuli that will be used

# This codes for the food stimulus offered now
img_now = visual.ImageStim(
    win = win_MRI_task,
    units = 'pix',
    size = [900,900],
    image = '/Users/u0127988/Documents/Psychopy/Definitief/Money_DDT/Geld/Geld_Lvl_1.png',
    pos = (-375,100)
    )

# This codes for the response triangles (left and right)
triangle_left = visual.ShapeStim(
    win = win_MRI_task,
    vertices = ((-0.5,0),(0,0.5),(0.5,0)),
    pos = (-380, -525),
    units = 'pix',
    size = 150,
    fillColor = [1,-1,-1] ,
    lineColor = [1,-1,-1]
    )

triangle_right = visual.ShapeStim(
    win = win_MRI_task,
    vertices = ((-0.5,0),(0,0.5),(0.5,0)),
    pos = (380, -525),
    units = 'pix',
    size = 150,
    fillColor = [1,-1,-1] ,
    lineColor = [1,-1,-1]
    )

# This codes for the food stimulus offered later
img_later=visual.ImageStim(
    win = win_MRI_task,
    units = 'pix',
    image = 'sin',
    size = [900,900],
    pos = (375,100)
)

# This codes the text for now
text_now = visual.TextStim(
    win = win_MRI_task,
    text = 'Nu',
    color = [1,1,1],
    height = 150,
    units = 'pix',
    pos = [-375, -375]
    )

# This codes the text for later
text_later = visual.TextStim(
    win = win_MRI_task,
    text = 'sin',
    color = [1,1,1],
    height = 150,
    units = 'pix',
    pos = [150, -375]
    )

# This codes the text for weken
text_minuten = visual.TextStim(
    win = win_MRI_task,
    text = 'Weken',
    color = [1,1,1],
    height = 150,
    units = 'pix',
    pos = [500, -375]
    )

# This codes the text for week
text_minuten_1 = visual.TextStim(
    win = win_MRI_task,
    text = 'Week',
    color = [1,1,1],
    height = 150,
    units = 'pix',
    pos = [500, -375]
    )

# This codes the properties of the fixation Cross that will be visible in the ISI
cross_MRI = visual.ShapeStim(
    win = win_MRI_task,
    vertices = 'cross',
    size = 150,
    units = 'pix',
    fillColor = [1,1,1],
    lineColor = [1,1,1]
)

# This codes for the lists en the entry numbers
list_2 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
list_3 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
list_4 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
list_5 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
i  = 9
j = 9
k = 9
l = 9 

# START OF THE EXPERIMENT


#Actual trial
for thisTrial in trials:
    if thisTrial != None:
        for paramName in thisTrial:
            exec('{} = thisTrial[paramName]'.format(paramName))
                # This resets the clock of the ISI, so that it will only be 6 seconds long
        clock_ISI.reset()
        exp.addData('start_run', globalClock.getTime())
        # This codes the length of the display of the ISI
        while clock_ISI.getTime() < 5:
            cross_MRI.draw()
            win_MRI_task.flip()
        #This presents the choice to the subject
        clock_Trial.reset()
        exp.addData('start_choice', globalClock.getTime())
        while clock_Trial.getTime() < 6:
            if beeld_geld == '/Users/u0127988/Documents/Psychopy/Definitief/Money_DDT/Geld/Geld_Lvl_2.png':
                number = random.randint(0,i)
                delay = list_2[number]
                text_later.setText(delay)
                list_2.remove(delay)
                i = i - 1
            if beeld_geld == '/Users/u0127988/Documents/Psychopy/Definitief/Money_DDT/Geld/Geld_Lvl_3.png':
                number = random.randint(0,j)
                delay = list_3[number]
                text_later.setText(delay)
                list_3.remove(delay)
                j = j - 1
            if beeld_geld == '/Users/u0127988/Documents/Psychopy/Definitief/Money_DDT/Geld/Geld_Lvl_4.png' :
                number = random.randint(0,k)
                delay = list_4[number]
                text_later.setText(delay)
                list_4.remove(delay)
                k = k - 1
            if beeld_geld == '/Users/u0127988/Documents/Psychopy/Definitief/Money_DDT/Geld/Geld_Lvl_5.png' :
                number = random.randint(0,l)
                delay = list_5[number]
                text_later.setText(delay)
                list_5.remove(delay)
                l= l - 1
            exp.addData('delay', delay)
            img_now.draw()
            img_later.setImage(beeld_geld)
            img_later.draw()
            text_later.draw()
            text_now.draw()
            if delay >1:
                text_minuten.draw()
            else:
                text_minuten_1.draw()
            win_MRI_task.flip()
            # This lets the subject answer with a maximum of 6 seconds
            keys = event.waitKeys(
                keyList = ['g','b'],
                maxWait = 6
                )
            exp.addData('response', keys)
            exp.addData('rt', clock_Trial.getTime())
            while clock_Trial.getTime() < 6:
                # This shows the answer the subject gave
                if keys != None:
                    if 'g' in keys:
                        triangle_left.draw()
                        img_now.draw()
                        img_later.draw()
                        text_now.draw()
                        text_later.draw()
                        if delay > 1:
                            text_minuten.draw()
                        else:
                            text_minuten_1.draw()
                        win_MRI_task.flip()
                    if 'b' in keys:
                        triangle_right.draw()
                        img_now.draw()
                        img_later.draw()
                        text_now.draw()
                        text_later.draw()
                        if delay > 1:
                            text_minuten.draw()
                        else:
                            text_minuten_1.draw()
                        win_MRI_task.flip()
        exp.nextEntry()


win_MRI_task.close()
