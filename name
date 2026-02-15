import asyncio
import aiohttp
from aiogram import Bot, Dispatcher, types
from aiogram.filters import Command
from aiogram.types import Message
from aiogram.fsm.context import FSMContext
from aiogram.fsm.state import State, StatesGroup
from aiogram.fsm.storage.memory import MemoryStorage
import os

# Берем данные из переменных окружения
API_TOKEN = os.environ.get('API_TOKEN')
NUMVERIFY_API_KEY = os.environ.get('NUMVERIFY_KEY')

bot = Bot(token=API_TOKEN)
storage = MemoryStorage()
dp = Dispatcher(storage=storage)

class Form(StatesGroup):
    waiting_for_number = State()

async def get_number_info(phone_number: str):
    try:
        clean_number = ''.join(filter(str.isdigit, phone_number))
        url = f"http://apilayer.net/api/validate?access_key={NUMVERIFY_API_KEY}&number={clean_number}&format=1"
        
        async with aiohttp.ClientSession() as session:
            async with session.get(url, timeout=10) as resp:
                data = await resp.json()
                
                if data.get('valid'):
                    return f"""valid\t{data.get('valid')}
number\t\"{data.get('number')}\"
local_format\t\"{data.get('local_format')}\"
international_format\t\"{data.get('international_format')}\"
country_prefix\t\"{data.get('country_prefix')}\"
country_code\t\"{data.get('country_code')}\"
country_name\t\"{data.get('country_name')}\"
location\t\"{data.get('location')}\"
carrier\t\"{data.get('carrier')}\"
line_type\t\"{data.get('line_type')}\""""
                else:
                    return "Номер недействителен"
    except:
        return "Ошибка проверки"

@dp.message(Command("start"))
async def cmd_start(message: Message, state: FSMContext):
    await message.answer("📱 Отправь номер")
    await state.set_state(Form.waiting_for_number)

@dp.message(Form.waiting_for_number)
async def process_number(message: Message, state: FSMContext):
    msg = await message.answer("⏳")
    result = await get_number_info(message.text.strip())
    await msg.edit_text(result)
    await state.clear()

async def main():
    await bot.delete_webhook()
    await dp.start_polling(bot)

if __name__ == "__main__":
    asyncio.run(main())
