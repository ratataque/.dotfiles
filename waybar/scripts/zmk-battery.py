#!/usr/bin/python3

from dbus_next.aio.message_bus import MessageBus
from dbus_next.constants import BusType
from dbus_next.errors import DBusError
import asyncio
import sys

BLUEZ = "org.bluez"
BLUEZ_PATH = (
    "/org/bluez/hci0"  # Change this to match your Bluetooth adapter and device address
)
GATT_SERVICE = "org.bluez.GattService1"
GATT_CHARACTERISTIC = "org.bluez.GattCharacteristic1"
GATT_CHARACTERISTIC_DESCR = "org.bluez.GattDescriptor1"
BATTERY_UUID = "0000180f-0000-1000-8000-00805f9b34fb"
BATTERY_LEVEL_UUID = "00002a19-0000-1000-8000-00805f9b34fb"
BATTERY_USER_DESC = "00002901-0000-1000-8000-00805f9b34fb"


async def retriev_levels(address):
    btAdapterAddr = address.replace(":", "_")
    BLUEZ_DEVICE_PATH = BLUEZ_PATH + "/dev_{}".format(btAdapterAddr)

    # print(f"Device Path: {BLUEZ_DEVICE_PATH}")

    try:
        bus = await MessageBus(bus_type=BusType.SYSTEM).connect()
        introspection = await bus.introspect(BLUEZ, BLUEZ_DEVICE_PATH)
        device = bus.get_proxy_object(BLUEZ, BLUEZ_DEVICE_PATH, introspection)
    except Exception as e:
        print(f"Error connecting to bus or introspecting device: {e}")
        return []

    levels = []

    try:
        for svc in device.child_paths:
            # print(f"Checking service: {svc}")
            intp = await bus.introspect(BLUEZ, svc)
            proxy = bus.get_proxy_object(BLUEZ, svc, intp)
            intf = proxy.get_interface(GATT_SERVICE)
            if BATTERY_UUID == await intf.get_uuid():
                for char in proxy.child_paths:
                    intp = await bus.introspect(BLUEZ, char)
                    proxy = bus.get_proxy_object(BLUEZ, char, intp)
                    intf = proxy.get_interface(GATT_CHARACTERISTIC)
                    level = int.from_bytes(
                        await intf.call_read_value({}), byteorder="big"
                    )
                    levels.append(level)
                    # print(f"Battery level found: {level}%")
    except Exception as e:
        # print(f"Error retrieving battery levels: {e}")
        e

    return levels


async def main():
    corne = "D1:06:22:C1:FD:85"  # Replace with the correct Bluetooth device address
    kinesis = "C6:84:E6:88:F6:43"  # Replace with the correct Bluetooth device address

    # print(f"Checking battery levels for device: {address}")

    try:
        corn_bat = await retriev_levels(corne)
        kinesis_bat = await retriev_levels(kinesis)
    except DBusError as e:
        print(f"DBus Error: {e}")
        print("x")
    except Exception as e:
        print(f"Unexpected error: {e}")
    else:
        if corn_bat:
            print(" / ".join([f"{x}%" for x in corn_bat]))
        elif kinesis_bat:
            print(" / ".join([f"{x}%" for x in kinesis_bat]))
        else:
            print("No battery levels found.")


if __name__ == "__main__":
    asyncio.run(main())
